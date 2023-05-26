# CameraKit RecordVideo Android 使用说明

## 版本说明:

| 库名称                 | 当前最新版本                                                                               |
|---------------------|--------------------------------------------------------------------------------------|
| BasicAuthentication | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.1.0-green"> |
| CameraKit           | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.1.0-green"> |

<br/>

## 1. 集成进项目

```gradle
// 添加远程 maven 仓库地址
repositories {
  maven { url 'https://repository.kiri-engine.com/repository/maven-public/' }
}

dependencies {
    // SDKs
    implementation 'com.kiri.sdk:BasicAuthentication:<version>'
    implementation 'com.kiri.sdk:CameraKit:<version>'

    // 以下依赖必须添加
    implementation "androidx.camera:camera-core:1.2.0-alpha02"
    implementation "androidx.camera:camera-lifecycle:1.2.0-alpha02"
    implementation 'androidx.camera:camera-view:1.2.0-alpha02'
    implementation "androidx.camera:camera-camera2:1.2.0-alpha02"
}
```

<br/>

## 2. 在 Application 中初始化 SDK

```Kotlin
class App : Application() {

    companion object {
        private const val TAG = "App"
    }

    override fun onCreate() {
        super.onCreate()

        // Init Kiri SDK first
        KiriSDK.init(
            context = this,
            isDebug = true,
            env = EnvType.Test,
            appKey = "Your app key",
            onSuccess = {
                KiriLogger.info(TAG, "SDK init completed!")
            },
            onError = { e ->
                // SDK Init error
                when (e) {
                    is AccountNotExistException -> {
                        KiriLogger.error(TAG, "Account does not exist!")
                    }
                    is AuthenticationException -> {
                        KiriLogger.error(TAG, "Account or password is incorrect!")
                    }
                    is ExhaustedException -> {
                        KiriLogger.error(TAG, "Quota used up!")
                    }
                    is SDKException -> {
                        KiriLogger.error(TAG, "SDK error: ${e.message}")
                    }
                    else -> {
                        KiriLogger.error(TAG, "SDK init failed, error: ${e.message}")
                    }
                }
            }
        )
    }

}
```

| 参数名称      | 说明                                                  |
|-----------|-----------------------------------------------------|
| context   | Context                                             |
| isDebug   | 是否为测试模式, 默认为非测试模式, 若为测试环境, 推荐打开                     |
| env       | SDK 环境, EnvType.Test 为测试, EnvType.Prod 为正式          |
| appKey    | 本 APP 授权的 appKey, 请勿泄露该 key, 且 key 只能使用在指定包名的 app 中 |
| onSuccess | SDK 初始化成功回调                                         |
| onError   | SDK 初始化失败回调, 会将异常信息带回                               |

可能在 onError 中出现的异常:

| 异常类型                     | 说明         | 解决方案          |
|--------------------------|------------|---------------|
| AccountNotExistException | 账号不存在      | 检查账号信息是否正确    |
| AuthenticationException  | 验证的账号或密码错误 | 检查账号信息是否正确    |
| ExhaustedException       | 接口的调用次数用尽  | 联系开发人员        |
| SDKException             | 接口的调用次数用尽  | 初始化失败, 联系开发人员 |

<br/>

## 3. Camera API

布局文件中使用:

```xml

<com.kiri.sdk.camerakit.view.RecordVideoView android:id="@+id/record_view"
    android:layout_width="match_parent" android:layout_height="match_parent" />
```

Kotlin API:

```Kotlin
// Init camera record and preview
recordView.bind(LifecycleOwner)

// Set Video save path
recordView.setSavePath(File)

// Set max video record time, unit seconds
recordView.setMaxRecordTime(10)

// Set min video record time, unit seconds
recordView.setMinRecordTime(3)

// Add RecordTime Change Listener, params is now time use seconds
recordView.setOnRecordTimeChange { second: Int ->
    runOnUiThread {
        // TODO You operations
    }
}

// Start video record action
recordView.startRecord(
    onSaved = { file: File ->
        // The record video file
    },
    onError = { e: Throwable ->
        // record some error...
    }
)

// Stop video record action
recordView.stopRecord()
```

方法说明:

| 方法名称                               | 说明                                                                       |
|------------------------------------|--------------------------------------------------------------------------|
| bind                               | 初始化相机和预览操作, 参数为 LifecycleOwner 对象, 会自动绑定生命周期                             |
| setSavePath                        | 设置拍摄的视频存放路径, 参数为 File 对象                                                 |
| setMaxRecordTime                   | 设置最大的录制时长，单位为秒，最小不能低于 3 秒，最大不能高于 120 秒，且与 MinRecordTime 互斥, 最小不能小于最低录制时长 |
| setMinRecordTime                   | 设置最小的录制时长，单位为秒，最小不能低于 3 秒，最大不能高于最大录制时长                                   |
| setOnRecordTimeChange(second: Int) | 录制过程中，用于监听目前的录制时长，单位为秒                                                   |
| startRecord                        | 开始录制操作                                                                   |
| stopRecord                         | 停止录制操作                                                                   |

<br/>

## 4. 示例代码

#### activity_main.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context="com.kiri.sdk.samples.basic.camera.record.demo.MainActivity">

    <com.kiri.sdk.camerakit.view.RecordVideoView android:id="@+id/record_view"
        android:layout_width="match_parent" android:layout_height="match_parent" />

    <androidx.appcompat.widget.AppCompatButton android:id="@+id/btn_record"
        android:layout_width="wrap_content" android:layout_height="wrap_content"
        android:layout_marginBottom="30dp" android:text="@string/start_record_text"
        app:layout_constraintBottom_toBottomOf="parent" app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### MainActivity.kt

```Kotlin
package com.kiri.sdk.samples.basic.camera.record.demo

import android.Manifest
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.kiri.sdk.basic.tool.VideoVerifyTool
import com.kiri.sdk.samples.basic.camera.record.demo.databinding.ActivityMainBinding
import com.tbruyelle.rxpermissions3.RxPermissions
import java.io.File


class MainActivity : AppCompatActivity() {

    companion object {
        private const val TAG = "MainActivity"
    }

    private val binding by lazy {
        ActivityMainBinding.inflate(layoutInflater)
    }

    private val rxPermissions = RxPermissions(this)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        // Request permissions
        rxPermissions.request(Manifest.permission.CAMERA).subscribe { granted ->
            if (granted) {
                binding.recordView.bind(this)
            }
        }

        initCameraRecord()
    }

    /**  Photo save dir  **/
    private val mediaDir by lazy {
        externalMediaDirs.firstOrNull()?.let {
            File(it, "Photo").apply { mkdirs() }
        } ?: filesDir
    }

    /**  Init CameraRecord Function API  **/
    private fun initCameraRecord() {
        // Set Photo save path
        binding.recordView.setSavePath(mediaDir)

        binding.recordView.setMaxRecordTime(10)
        binding.recordView.setMaxRecordTime(3)

        // Add RecordTime Change Listener
        binding.recordView.setOnRecordTimeChange { second: Int ->
            runOnUiThread {
                Log.e(TAG, "second -> $second")
            }
        }

        // Record video
        binding.btnRecord.setOnClickListener {
            binding.recordView.startRecord(
                onSaved = { file ->
                    Log.e(TAG, "Record success, file: ${file.absoluteFile}")
                    // TODO Use VideoVerifyTool get special key to upload server
                    val specialKey = VideoVerifyTool.verify(file)
                },
                onError = { e ->
                    Log.e(TAG, "Record error, error: ${e.message}")
                }
            )
        }
    }

}
```

<br/>

英文版本: [English version](README.md)