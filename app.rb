load 'config.rb'
require 'rest-client'
require 'json'
require 'base64'
require 'open-uri'

API_URL = 'https://developer.api.autodesk.com'
BUCKET_KEY = "forge-java-sample-app-#{CLIENT_ID.downcase}"
FILE_NAME = 'my-elephant.obj'
FILE_PATH = 'elephant.obj'

# 2 Legged Authentication in Forge - returns the access token
def get_access_token
  response = RestClient.post("#{API_URL}/authentication/v1/authenticate",
                             { client_id: CLIENT_ID, client_secret: CLIENT_SECRET, grant_type:'client_credentials',scope:'data:read data:write bucket:create' })
  return JSON.parse(response.body)['access_token']
end

# Create a new bucket in Forge API.
def create_bucket(bucket_key,access_token)
  response = RestClient.post("#{API_URL}/oss/v2/buckets",
                             { bucketKey: bucket_key, policyKey:'transient'}.to_json,
                             { Authorization: "Bearer #{access_token}", content_type:'application/json' })
  return response
end

# Upload a file to a previously created bucket
def upload_file(bucket_key,file_location,file_name,access_token)
  file_uploaded = File.new(file_location, 'rb')
  response = RestClient.put("#{API_URL}/oss/v2/buckets/#{bucket_key}/objects/#{file_name}",
                             file_uploaded,
                             { Authorization: "Bearer #{access_token}", content_type:'application/octet-stream'})
  return response
end

# Translate previously uploaded file to SVF format
def translate_to_svf(object_id,access_token)
  base_64_urn = Base64.strict_encode64(object_id)
  response = RestClient.post("#{API_URL}/modelderivative/v2/designdata/job",
                             {
                                 input: {
                                     urn: base_64_urn
                                 },
                                 output: {
                                     formats: [
                                         {
                                             type: "svf",
                                             views: [
                                                 "3d"
                                             ]
                                         }
                                     ]
                                 }
                             }.to_json,
                             { Authorization: "Bearer #{access_token}", content_type:'application/json' })
  return response
end

# Poll the status of the job until it's done
def verify_job_complete(base_64_urn,access_token)
  is_complete = false

  while(!is_complete)
    response = RestClient.get("#{API_URL}/modelderivative/v2/designdata/#{base_64_urn}/manifest",
                              { Authorization: "Bearer #{access_token}"} )
    json = JSON.parse(response.body)
    if(json["progress"]=="complete")
      is_complete = true
      puts("***** Finished translating your file to SVF - status: #{json['status']}, progress: #{json['progress']} ")
    else
      puts("***** Haven't finished translating your file to SVF - status: #{json['status']}, progress: #{json['progress']} ")
      sleep 1
    end
  end

  return response
end

# Puts the url of the viewer for the user to open.
def open_viewer(urn,access_token)
  path = File.expand_path(File.dirname(__FILE__))
  url = "file://#{path}/viewer.html?token=#{access_token}&urn=#{urn}"
  text_to_print_in_color = "Please open the following url in your favorite browser:\n#{url}"
  puts("\e[44m#{text_to_print_in_color}\e[0m")

end

begin
  access_token = get_access_token
  puts("***** Got access token: #{access_token}")

  begin
    create_bucket_response = create_bucket(BUCKET_KEY, access_token)
    puts("***** Create bucket response: #{create_bucket_response}")
  rescue RestClient::Exception => e
    puts(e.response)
  end

  upload_response = upload_file(BUCKET_KEY,FILE_PATH,FILE_NAME,access_token)
  puts("***** Upload file response: #{upload_response}")
  urn = JSON.parse(upload_response.body)['objectId']

  translate_job_response = translate_to_svf(urn,access_token)
  puts("***** translate to svf response: #{translate_job_response}")

  urn_encoded = JSON.parse(translate_job_response.body)["urn"]

  verify_response = verify_job_complete(urn_encoded,access_token)
  puts("***** translate to svf complete response: #{verify_response}")

  if(JSON.parse(verify_response.body)["status"]=='success')
    open_viewer(urn_encoded,access_token)
  end

rescue RestClient::Exception => e
  puts "caught exception #{e.message}! #{e.response} #{e.backtrace}"
end