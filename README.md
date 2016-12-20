# Forge Ruby Sample App

## Overview
This sample app uses the Forge Java SDK to introduces the [OAuth](https://developer.autodesk.com/en/docs/oauth/v2/overview/), [Data Management](https://developer.autodesk.com/en/docs/data/v2/overview/) and [Model Derivative](https://developer.autodesk.com/en/docs/model-derivative/v2/overview/) Forge APIs. It shows the following workflow:

* Create a 2-legged authentication token
* Create a bucket (an arbitrary space to store objects)
* Upload a file to the bucket
* Translate into SVF
* Show translated file at the Viewer

### Requirements
* Ruby version > 2.0

### Installation
Clone this following repository.
```$ sudo gem install rest-client ```

### Create an App

[Create an app](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) on the Forge Developer portal, and ensure that you select the Data Management API. Note the client ID and client secret.

### Configure the Parameters

Before running the app you need to configure the following parameters from the *config.rb* file:

* Replace `CLIENT_ID` and `CLIENT_SECRET` with the client ID and client secret generated when creating the app.

### Run the App
```$ ruby app.rb ```
## Support
forge.help@autodesk.com
