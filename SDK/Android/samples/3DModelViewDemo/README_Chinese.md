## 3DModelDisplayKit Android 的使用

## [English version](README.md)

## 版本说明:

| 库名称 | 当前最新版本 |
| ----- | ----- |
| BasicAuthentication | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |
| 3DModelDisplayKit | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |

## 1. 集成进项目

```groovy
// 添加远程 maven 仓库地址
repositories {
    maven { url 'https://repository.kiri-engine.com/repository/maven-public/' }
}

dependencies {
    // SDKs
    implementation 'com.kiri.sdk:BasicAuthentication:<version>'
    implementation 'com.kiri.sdk:3DModelKit:<version>'
}
```

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

### 3. 在 MainActivity.xml 中引入 ModelView 控件

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent">

    <com.kiri.sdk.modelkit.view.ModelView android:id="@+id/model_view"
        android:layout_width="match_parent" android:layout_height="0dp"
        app:layout_constraintBottom_toBottomOf="parent" app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" app:layout_constraintTop_toTopOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

### 4. 在 MainActivity.kt 中使用动态模型载入

```Kotlin
package com.kiri.sdk.samples.model.view.demo

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.lifecycle.lifecycleScope
import com.kiri.sdk.modelkit.Color
import com.kiri.sdk.modelkit.ext.assetsForm
import com.kiri.sdk.modelkit.ext.bitmapFormAssets
import com.kiri.sdk.modelkit.loader.ObjTextureLoader
import com.kiri.sdk.modelkit.model.sub.ObjTextureModel
import com.kiri.sdk.samples.model.view.demo.databinding.ActivityMainBinding
import kotlinx.coroutines.launch

class MainActivity : AppCompatActivity() {

    companion object {
        private const val TAG = "MainActivity"

        private const val objFileName = "Waffle"
        private const val objBasePath = "models/obj/$objFileName"
    }

    private val binding by lazy {
        ActivityMainBinding.inflate(layoutInflater)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(binding.root)

        initModel()
    }

    private fun initModel() = lifecycleScope.launch {
        // Prepare model file & texture file
        val objectData = ObjTextureLoader.loadData(
            // OBJ File
            assetsForm("$objBasePath/$objFileName.obj"),
            // Texture File
            bitmapFormAssets("$objBasePath/$objFileName.jpg")
        )

        // Prepare ModelData
        val model = ObjTextureModel(objectData)

        // Put ModelData to Scene
        binding.modelView.initScene(model)

        // Set ModelView BackgroundColor
        binding.modelView.setBackgroundColor(Color(0x1E1E1E))
    }

    override fun onResume() {
        super.onResume()
        binding.modelView.onResume()
    }

    override fun onPause() {
        super.onPause()
        binding.modelView.onPause()
    }

}
```
