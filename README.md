# Forge Ruby Sample App

[![OAuth2](https://img.shields.io/badge/OAuth2-v1-green.svg)](http://forge.autodesk.com/)
[![Data-Management](https://img.shields.io/badge/Data%20Management-v2-green.svg)](http://forge.autodesk.com/)
[![Viewer](https://img.shields.io/badge/Viewer-v7-green.svg)](https://forge.autodesk.com/)

## Overview
This sample app demonstrates how to use the [OAuth](https://developer.autodesk.com/en/docs/oauth/v2/overview/), [Data Management](https://developer.autodesk.com/en/docs/data/v2/overview/) and [Model Derivative](https://developer.autodesk.com/en/docs/model-derivative/v2/overview/) Forge APIs, as well as the Forge [Viewer](https://developer.autodesk.com/en/docs/viewer/v7/overview/) JavaScript library. It shows the following typical workflow:

* Create a 2-legged authentication token
* Create a bucket (an arbitrary space to store objects)
* Upload a file to the bucket
* Prepare the file for displaying in the Viewer (translate the file into SVF format)
* Show the translated file in the Viewer

### Requirements
Ruby version 2.0 and above.

### Installation
```$ sudo gem install rest-client ```

### Create an App

[Create an app](https://developer.autodesk.com/en/docs/oauth/v2/tutorials/create-app/) on the Forge Developer portal, and ensure that you select the Data Management and Model Derivative APIs. Note the client ID and client secret.

### Configure the Parameters

Open the *config.rb* file, and replace `CLIENT_ID` and `CLIENT_SECRET` with the client ID and client secret generated when creating the app.

### Run the App
```$ ruby app.rb ```

![thumbnail](/thumbnail.png)

## Support
forge.help@autodesk.com