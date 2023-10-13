# KIRIENGINE API Instruction

## 1. Get token

Request URL: /v1/app/auth/open/getToken

After account registration, use "Get Token" api to get token and then access to other KIRI ENGINE services. 

**token expires in 30 mins，please cache it so that you do not have to request token everytime.**

## 2. Update account information

Request URL: /v1/app/organization/update

You can update your account information. e.g. Change password or NotifyUrl <br/>

## 3. Upload photos

Request URL: /v1/app/calculate/upload

Use this API to upload the photoset to KIRI ENGINE server and get serialize number of the model. This serialize number is unique for this project. 
To ensure the quality of the 3d models, please upload at least 20 images but no more than 70 images. If you need upload more, please contact us.

**We have recently launched the V2 version of our API, which supports custom model quality, texture quality, and AI Object Masking. For more details, please refer to the API documentation**

| Code | Description                                                  |
| ---- | ------------------------------------------------------------ |
| 2004 | Uploaded photoset is empty, please check                     |
| 2007 | Uploaded photoset does not meet minimum requeirment，Please upload at least 20 images |
| 2005 | Uploaded photoset exceeded the maximum limitation            |

## 4. Get 3d Model Status

Request URL: /v1/app/calculate/getStatus

Pass the serialize number to this API to get the current calculation status of the 3d model.

| Status | description                                  |
| ------ | -------------------------------------------- |
| -1     | The image upload is incomplete. Please wait. |
| 0      | Processing                                   |
| 1      | Failed                                       |
| 2      | Successful                                   |
| 3      | Queuing                                      |
| 4      | Exported                                     |

## 5. Download 3d model zip file

Request URL: /v1/app/calculate/getModelZip

Use this API to get 3d model zip file download link. This link will be available in 60 mins.

| Code | Description                                                  |
| ---- | ------------------------------------------------------------ |
| 2000 | This model status is processing, please wait                 |
| 2001 | This model status is failed，cannot get download link        |
| 2008 | This model status is queueing, please wait                   |
| 2002 | This model has been exported already, cannot get download link |
| 2003 | Error, cannot get status of this model                       |

## 6. Test notification

Request URL:  /v1/app/organization/testNotify

This API to test if you can receive the 3d model status broadcast from KIRI ENGINE server.

**Cautions：** 

**1、Please make sure the NotifyUrl can be accessed.** 

**2、Please make sure use post method and json format to receive the status and serialize informations.** 

**3、Please return HTTP code 200 to our server if you receive the notification.**

## 7. Create Subaccount

Request URL: /v1/app/user/create

If there are multiple account usage scenarios, we recommend creating a subaccount and using the subaccount to log in and obtain a token (refer to 9). This way, you can upload images using the subaccount, which has almost the same functionality as the main organization account.

## 8. Update Subaccount

Request URL: /v1/app/user/update

Considering that some users may require additional notification settings, we support setting notification addresses on sub-accounts as well. If a sub-account is used to upload images, notifications regarding that task will be prioritized to the notification address set on the sub-account. If no notification address is set on the sub-account, then the notification will be sent to the organization account.

## 9. Subaccount Login

Request URL: /v1/app/auth/open/login

Use this entry point to log in to a subaccount and obtain a token, following the same process as the main organization account.

## 10. Create AppKey

Request URL: /v1/app/sdk/createAppKey.

## 11. Globle code instruction

| Code | Description                                | Solution                                   |
| ---- | ------------------------------------------ | ------------------------------------------ |
| -1   | No valid token                             | Please make sure the header includes token |
| -2   | Token invalid                              | Please get token again                     |
| -3   | Token expired                              | Please get token again                     |
| 3002 | Crediential used up                        | Please contact us                          |
| 1003 | This account does not have valid notifyUrl | Please check if notifyUrl is correct       |

