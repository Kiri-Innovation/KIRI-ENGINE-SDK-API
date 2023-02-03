# KIRIENGINE SDK API Instruction

## 1. Register an account

Request method: /v1/app/organization/open/create

KIRI ENGINE 3D scanning service will be provided to authorized account. Account name and password can be customized. If notification is need, please fill in notifyUrl
argument to receive the status broadcast. Please refer to number 7 to do the test.

| Code | Description        |
| ---- | ------------------ |
| 1002 | Account already exists|

## 2. Get token

Request method: /v1/app/auth/open/getToken

After account registration, use "Get Token" api to get token and then access to other KIRI ENGINE services. 

**token expires in 30 mins，please cache it so that you do not have to request token everytime.**

## 3. Update account information

Request method: /v1/app/organization/update

You can update your account information. e.g. Change password or NotifyUrl <br/>

## 4. Upload photos

Request method: /v1/app/calculate/upload

Use this API to upload the photoset to KIRI ENGINE server and get serialize number of the model. This serialize number is unique for this project. 
To ensure the quality of the 3d models, please upload at least 20 images but no more than 70 images. If you need upload more, please contact us.

| Code | Description                           |
| ---- | ------------------------------------- |
| 2004 | Uploaded photoset is empty, please check|
| 2007 | Uploaded photoset does not meet minimum requeirment，Please upload at least 20 images |
| 2005 | Uploaded photoset exceeded the maximum limitation|

## 5. Get 3d Model Status

Request method: /v1/app/calculate/getStatus

Pass the serialize number to this API to get the current calculation status of the 3d model.

| Status | description             |
| ---- | ------------------------- |
| 0    | Processing                |
| 1    | Failed                    |
| 2    | Successful                |
| 3    | Queuing                   |
| 4    | Exported                  |

## 6. Download 3d model zip file

Request method: /v1/app/calculate/getModelZip

Use this API to get 3d model zip file download link. This link will be available in 60 mins.

| Code | Description                             |
| ---- | -------------------------------- |
| 2000 | This model status is processing, please wait            |
| 2001 | This model status is failed，cannot get download link | 
| 2008 | This model status is queueing, please wait      |
| 2002 | This model has been exported already, cannot get download link       |
| 2003 | Error, cannot get status of this model                     |

## 7. Test notification

Request method:  /v1/app/organization/testNotify

This API to test if you can receive the 3d model status broadcast from KIRI ENGINE server.

**Cautions：** 

**1、Please make sure the NotifyUrl can be accessed.** 

**2、Please make sure use post method and json format to receive the status and serialize informations.** 

**3、Please return HTTP code 200 to our server if you receive the notification.**

## 8. Globle code instruction

| Code | Description                             | Solution                    |
| ---- | -------------------------------- | --------------------------- |
| -1   | No valid token                  | Please make sure the header includes token |
| -2   | Token invalid                        | Please get token again              |
| -3   | Token expired                     | Please get token again             |
| 3002 | Crediential used up                 | Please contact us                  |
| 1003 | This account does not have valid notifyUrl | Please check if notifyUrl is correct     |

