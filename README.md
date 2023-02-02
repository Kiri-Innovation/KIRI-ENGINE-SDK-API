# Kiri server  使用说明

## 1. 注册账号

请求地址: /v1/app/organization/open/create

kiri服务通过账号的方式授权使用服务,可自定义账号密码，如若需要模型状态变更通知，可选填notifyUrl参数用于接收模型处理状态的通知，如需测试配置是否成功接收kiri服务通知，请看第七条。

| code | 说明             |
| ---- | ---------------- |
| 1002 | 该账户名已经存在 |

## 2.获取授权	

请求地址: /v1/app/auth/open/getToken

注册账号完成后，请求“获取授权”接口拿到kiri服务的token用于后续接口的授权，服务端会通过这次请求把token放入浏览器cookie中，也可以在http请求中带入浏览器header

**token过期时间30分钟，建议通过其他方式缓存，尽量减少请求次数。**

![image-20230113162342483](/Users/xuefengwang/Library/Application Support/typora-user-images/image-20230113162342483.png)

## 3. 修改账号

请求地址: /v1/app/organization/update

可以修改密码或者通知地址和其他账户信息。<br/>

## 4. 上传图片

请求地址: /v1/app/calculate/upload

通过该接口将需要计算的图片上传到kiri服务后返回模型序列号，该序列号用于管理所有模型相关服务，保证唯一。为了保证3d模型的效果，请至少上传20张图片，目前最大支持70张照片，理论上来说照片质量越好3d模型效果就越好，如果需要能支持上传更多的图片，请联系我们。

| code | 说明                         |
| ---- | ---------------------------- |
| 2004 | 上传图片为空 请检查          |
| 2007 | 图片数量不足，最少请上传20张 |
| 2005 | 图片数量已经超出最大限制     |

## 5. 获取模型状态
请求地址: /v1/app/calculate/getStatus

在上传图片之后，您的模型就进入准备运算的阶段，传入序列号通过该接口获取到目前的模型状态

目前模型定义的全局状态：

| 状态 | 说明                       |
| ---- | -------------------------- |
| 0    | 图片正在计算中生成3d模型   |
| 1    | 3d模型生成失败，请检查图片 |
| 2    | 模型生成成功，可以导出     |
| 3    | 生成3d模型正在排队中       |
| 4    | 3d模型已导出               |

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
