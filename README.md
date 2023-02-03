# KIRIENGINE SDK API Instruction

## 1. Register an account

Request method: /v1/app/organization/open/create

KIRI ENGINE 3D scanning service will be provided to authorized account. Account name and password can be customized. If notification is need, please fill in notifyUrl
argument to receive the status broadcast. Please refer to number 7 to do the test.

| code | description        |
| ---- | ------------------ |
| 1002 | Account is existing|

## 2. Get Token

Request method: /v1/app/auth/open/getToken

After account registration, use "Get Token" api to get token and then access to other KIRI ENGINE services. 

**token expires in 30 mins，please cache it so that you do not have to request token everytime.**

![image-20230113162342483](/Users/xuefengwang/Library/Application Support/typora-user-images/image-20230113162342483.png)

## 3. Update account information

Request method: /v1/app/organization/update

You can update your account information. e.g. Change password or NotifyUrl <br/>

## 4. Upload photos

Request method: /v1/app/calculate/upload

Use this API to upload the photoset to KIRI ENGINE server and get serialize number of the model. This serialize number is unique for this project. 
To ensure the quality of the 3d models, please upload at least 20 images but no more than 70 images. If you need upload more, please contact us.

| code | description                           |
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

## 6. 下载模型zip

请求地址: /v1/app/calculate/getModelZip

当图片计算已经完成后，即可通过该接口获取运行模型后的下载链接，该链接六十分钟内有效请及时下载

| code | 说明                             |      |
| ---- | -------------------------------- | ---- |
| 2000 | 该模型正在计算处理中             |      |
| 2001 | 该模型运算失败，无法获取下载地址 |      |
| 2008 | 该模型处理排队中，请稍后         |      |
| 2002 | 模型不存在,该模型已经下载过      |      |
| 2003 | 模型状态异常                     |      |

## 7. 测试通知

请求地址:  /v1/app/organization/testNotify

用于接受测试是否能收到kiri服务模型状态通知

**注意事项：** 

**1、需要确保填写的地址公网可以访问**

**2、确保接收参数为status(模型状态)和serialize(模型序列号)接受请求必须为post方式json格式接收** 

**3、通知完成服务器请返回HTTP code 200 ，kiri服务确认请求成功** 



## 8. 全局code说明

| code | 说明                             | 解决方案                    |
| ---- | -------------------------------- | --------------------------- |
| -1   | 未读取有效token                  | 请检查header中是否带入token |
| -2   | Token无效                        | 请重新获取授权              |
| -3   | Token已过期                      | 请重新获取授权              |
| 3002 | 接口调用次数不足                 | 请联系我们                  |
| 1003 | 该账户未配置通知地址或地址不合法 | 请检查notifyUrl是否正确     |
