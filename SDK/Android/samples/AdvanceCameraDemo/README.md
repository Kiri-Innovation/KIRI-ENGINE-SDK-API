# AdvanceCameraKit Android 使用说明

## [中文版本](README_Chinese.md)

## 版本说明:

| 库名称 | 当前最新版本 |
| ----- | ----- |
| BasicAuthentication | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |
| CameraKit | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |

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

| 参数名称 | 说明 |
| ----- | ----- |
| context | Context |
| isDebug | 是否为测试模式, 默认为非测试模式, 若为测试环境, 推荐打开 |
| env | SDK 环境, EnvType.Test 为测试, EnvType.Prod 为正式 |
| appKey | 本 APP 授权的 appKey, 请勿泄露该 key, 且 key 只能使用在指定包名的 app 中 |
| onSuccess | SDK 初始化成功回调 |
| onError | SDK 初始化失败回调, 会将异常信息带回 |

可能在 onError 中出现的异常:

| 异常类型 | 说明 | 解决方案 |
| ----- | ----- | -----|
| AccountNotExistException | 账号不存在 | 检查账号信息是否正确 |
| AuthenticationException | 验证的账号或密码错误 | 检查账号信息是否正确 |
| ExhaustedException | 接口的调用次数用尽 | 联系开发人员 |
| SDKException | 接口的调用次数用尽 | 初始化失败, 联系开发人员 |

<br/>

## 3. Camera API

布局文件中使用:

```xml

<com.kiri.sdk.camerakit.view.CameraView android:id="@+id/camera_view"
    android:layout_width="match_parent" android:layout_height="match_parent" />
```

Kotlin API:

```Kotlin
// Init camera and preview
cameraView.bind(LifecycleOwner)

// 获取可以调整的 ev, iso, ss 的范围区间值
cameraView.advAdjustInfo

// 可以调整的 ev 范围, List<ParamsEntity> 类型
cameraView.advAdjustInfo?.ev

// 可以调整的 iso 范围, List<ParamsEntity> 类型
cameraView.advAdjustInfo?.iso

// 可以调整的 ss 范围, List<ParamsEntity> 类型
cameraView.advAdjustInfo?.ss

// 设置相机预览时动态 iso, ss, ev 值变化的回调
cameraView.setOnPreviewAdvParamsChange(OnPreviewAdvParamsChangeListener)

// 设置相机当前的 EV 值
cameraView.controlEV(ParamsEntity)

// 设置相机当前的 ISO 值
cameraView.controlISO(ParamsEntity)

// 设置相机当前的 SS 值
cameraView.controlSS(ParamsEntity)

// 重置当前相机的 EV, ISO, SS 值
cameraView.resetAdv()

// 修改当前相机的测光模式, 可选项为: CameraAdvanceMode.Auto (自动测光), CameraAdvanceMode.Manual (手动测光)
cameraView.changeAdvMode(CameraAdvanceMode)

// 获取相机当前的测光模式, 对应 changeAdvMode 设置的值, 默认为 CameraAdvanceMode.Auto (自动测光)
cameraView.advMode

// 设置拍摄的照片存放路径
cameraView.setSavePath(File)

// 设置拍摄相关的事件回调
cameraView.setTakePictureListener(object : OnTakePictureListener {
    override fun onTaken(photoFile: File) {
        Log.e(TAG, "已拍摄一张照片, 存放位置为: ${photoFile.absolutePath}")
    }

    override fun onTakeError(exception: Exception) {
        Log.e(TAG, "照片拍摄出错, 异常为: ${exception.message}")
    }
})

// 拍摄照片
cameraView.takePicture()
```

方法说明:

| 方法名称 | 说明 |
| ----- | ----- |
| bind | 初始化相机和预览操作, 参数为 LifecycleOwner 对象, 会自动绑定生命周期 |
| setSavePath | 设置拍摄的照片存放路径, 参数为 File 对象 |
| setTakePictureListener | 设置拍摄相关的事件回调，为 OnTakePictureListener 类型 |
| takePicture | 拍摄照片 |
| setOnPreviewAdvParamsChange | 设置相机预览时动态 iso, ss, ev 值变化的回调 |
| controlEV | 设置相机当前的 EV 值 |
| controlISO | 设置相机当前的 ISO 值 |
| controlSS | 设置相机当前的 SS 值 |
| resetAdv | 重置当前相机的 EV, ISO, SS 值 |

<br/>

OnTakePictureListener 声明:

| 返回类型 | 方法签名 | 说明 |
| ----- | ----- | ----- |
| void | onTaken(photoFile: File) | 拍摄并保存单张照片成功的回调方法, 会将本次拍摄成功的照片文件返回回来 |
| void | onTakeError(exception: Exception) | 拍摄发生异常时的回调, 参数会将本次的异常信息携带回来 |

<br/>

ParamsEntity 声明:

| 变量类型 | 变量名 | 说明 |
| ----- | ----- | ----- |
| String | formatStr | 当前值用于格式化的字符串 |
| Float | value | 当前参数实际需要传递给相机的值 |
| Int | step | 当前参数类型实际间隔的 UI 步长 |
| Int | index | 当前参数实际在范围列表中的索引位置 |

| 返回类型 | 方法签名 | 说明 |
| ----- | ----- | ----- |
| Boolean | isEmpty() | 当前参数对象是否为空对象, 定义为 formatStr 为空字符串 & value = -1 & step = -1 & index = -1 |

<br/>

OnPreviewAdvParamsChangeListener 声明:

| 返回类型 | 方法签名 | 说明 |
| ----- | ----- | ----- |
| void | onPreviewAdvParamsChanged(previewParams: PreviewAdvParams) | 当当前相机预览的 iso, ss, ev 发生变化时会回调该方法 |

<br/>

PreviewAdvParams 声明:

| 变量类型 | 变量名 | 说明 |
| ----- | ----- | ----- |
| ParamsEntity | iso | 当前预览时的 iso 参数值 |
| ParamsEntity | ss | 当前预览时的 ss 参数值 |
| ParamsEntity | ev | 当前预览时的 ev 参数值 |

⚠️ 注意：相机权限需要自行动态申请

## 4. 示例代码

#### activity_main.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" tools:context=".MainActivity">

    ......

    <com.kiri.sdk.camerakit.view.CameraView android:id="@+id/camera_view"
        android:layout_width="match_parent" android:layout_height="match_parent" />

    ......

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### MainActivity.kt

```Kotlin
package com.kiri.sdk.samples.advance.camera.demo

import android.Manifest
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.SeekBar
import androidx.core.view.isGone
import com.kiri.sdk.camerakit.entity.AdvanceCameraAdjustParams
import com.kiri.sdk.camerakit.entity.PreviewAdvParams
import com.kiri.sdk.camerakit.tool.CameraAdvanceMode
import com.kiri.sdk.camerakit.view.OnPreviewAdvParamsChangeListener
import com.kiri.sdk.camerakit.view.OnTakePictureListener
import com.kiri.sdk.samples.advance.camera.demo.databinding.ActivityMainBinding
import com.tbruyelle.rxpermissions3.RxPermissions
import java.io.File
import java.lang.Exception


class MainActivity : AppCompatActivity(), OnPreviewAdvParamsChangeListener {

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

        // Default format now adv params
        binding.tvNowEv.text = getString(R.string.now_ev, "--")
        binding.tvNowIso.text = getString(R.string.now_ev, "--")
        binding.tvNowSs.text = getString(R.string.now_ev, "--")

        // Request permissions
        rxPermissions.request(Manifest.permission.CAMERA).subscribe { granted ->
            if (granted) bindCameraAndInitAdv()
        }

        initCamera()
    }

    /**  Photo save dir  **/
    private val mediaDir by lazy {
        externalMediaDirs.firstOrNull()?.let {
            File(it, "Photo").apply { mkdirs() }
        } ?: filesDir
    }

    /**  Init Camera Function API  **/
    private fun initCamera() {
        // Set Photo save path
        binding.cameraView.setSavePath(mediaDir)

        // Set take state callback
        binding.cameraView.setTakePictureListener(object : OnTakePictureListener {
            override fun onTaken(photoFile: File) {
                Log.e(TAG, "Taken a photo, save as: ${photoFile.absolutePath}")
            }

            override fun onTakeError(exception: Exception) {
                Log.e(TAG, "Taken error, error: ${exception.message}")
            }
        })

        // Take picture
        binding.btnTaken.setOnClickListener {
            binding.cameraView.takePicture()
        }

        // Adv Mode Switcher
        binding.btnAdvMode.setOnClickListener {
            when (binding.cameraView.advMode) {
                CameraAdvanceMode.Auto -> {
                    binding.cameraView.advManualMode()
                    binding.llAdjustArea.isGone = false
                    binding.btnAdvMode.text = getString(R.string.manual_mode_text)
                }
                CameraAdvanceMode.Manual -> {
                    binding.cameraView.advAutoMode()
                    binding.llAdjustArea.isGone = true
                    binding.btnAdvMode.text = getString(R.string.auto_mode_text)
                }
            }
        }
    }

    private var advAdjustInfo: AdvanceCameraAdjustParams? = null

    private fun bindCameraAndInitAdv() {
        binding.cameraView.bind(this)

        // Bind Adv camera params to panel view
        binding.cameraView.advAdjustInfo?.apply {
            this@MainActivity.advAdjustInfo = this
            updateAdvProgressBarLimit()
        }

        // Add Preview Adv Params Change callback to refresh UI
        binding.cameraView.setOnPreviewAdvParamsChange(this)
    }

    private val seekBarListener = object : SeekBar.OnSeekBarChangeListener {
        override fun onProgressChanged(seekBar: SeekBar, progress: Int, fromUser: Boolean) {
            onAdvProgressChange(seekBar.id, progress)
        }

        override fun onStartTrackingTouch(seekBar: SeekBar) {
        }

        override fun onStopTrackingTouch(seekBar: SeekBar) {
        }
    }

    private fun onAdvProgressChange(id: Int, progress: Int) {
        advAdjustInfo?.apply {
            when (id) {
                R.id.seekbar_ev -> {
                    val selectEV = ev[progress]
                    binding.tvEvValue.text = selectEV.formatStr

                    binding.cameraView.controlEV(selectEV)
                }
                R.id.seekbar_iso -> {
                    val selectISO = iso[progress]
                    binding.tvIsoValue.text = selectISO.formatStr

                    binding.cameraView.controlISO(selectISO)
                }
                R.id.seekbar_ss -> {
                    val selectSS = ss[progress]
                    binding.tvSsValue.text = selectSS.formatStr

                    binding.cameraView.controlSS(selectSS)
                }
            }
        }
    }

    private fun updateAdvProgressBarLimit() {
        advAdjustInfo?.apply {
            binding.seekbarEv.max = ev.lastIndex
            binding.seekbarEv.setOnSeekBarChangeListener(seekBarListener)
            binding.tvEvValue.text = ev.first().formatStr

            binding.seekbarIso.max = iso.lastIndex
            binding.seekbarIso.setOnSeekBarChangeListener(seekBarListener)
            binding.tvIsoValue.text = iso.first().formatStr

            binding.seekbarSs.max = ss.lastIndex
            binding.seekbarSs.setOnSeekBarChangeListener(seekBarListener)
            binding.tvSsValue.text = ss.first().formatStr
        }
    }

    override fun onPreviewAdvParamsChanged(previewParams: PreviewAdvParams) {
        // Update now adv params UI
        binding.tvNowEv.text = getString(R.string.now_ev, previewParams.ev.formatStr)
        binding.tvNowIso.text = getString(R.string.now_ev, previewParams.iso.formatStr)
        binding.tvNowSs.text = getString(R.string.now_ev, previewParams.ss.formatStr)
    }

}
```