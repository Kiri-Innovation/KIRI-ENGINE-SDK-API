## 3DModelDisplayKit Android Usage

## Version description:

| Library name | Latest version |
| ----- | ----- |
| BasicAuthentication | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |
| 3DModelDisplayKit | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.0.0-green"> |

## 1. Integrate to project

```groovy
// Add maven address
repositories {
    maven { url 'https://repository.kiri-engine.com/repository/maven-public/' }
}

dependencies {
    // SDKs
    implementation 'com.kiri.sdk:BasicAuthentication:<version>'
    implementation 'com.kiri.sdk:3DModelKit:<version>'
}
```

## 2. Initialize SDK in Application

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

| Parameter Name | Description |
| ----- | ----- |
| context | Context |
| isDebug | if this is Debug mode. Default is off. If you are in testing environment, we recommend you turn this on |
| env | SDK environment, EnvType.Test is Testing environment, EnvType.Prod is Production environment |
| appKey | App key is the unique key can be used in certain app package. Please do not give to others|
| onSuccess | initialize SDK successfully |
| onError | initialize SDK failed, will return the fail reason |

Possible errors in onError:

| Error type | Description | Solution |
| ----- | ----- | -----|
| AccountNotExistException | Account does not exist | Check if account info is correct |
| AuthenticationException | Account or password incorrect | Check if account info is correct |
| ExhaustedException | Credits used up | Please contact us |
| SDKException | Credits used up | Please contact us |

<br/>

### 3. Add ModelView widget in MainActivity.xml

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

### 4. Load model in MainActivity.kt

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

<br/>

Chinese version: [中文版本](README_Chinese.md)
