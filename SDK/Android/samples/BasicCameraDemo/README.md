# CameraKit Android Usage

## Version description:

| Library name | Latest version                                                                       |
| ----- |--------------------------------------------------------------------------------------|
| CameraKit | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.2.0-green"> |

<br/>

## 1. Integrate to project

```gradle
// Add maven address
repositories {
  maven { url 'https://repository.kiri-engine.com/repository/maven-public/' }
}

dependencies {
    // SDKs
    implementation 'com.kiri.sdk:CameraKit:<version>'

    // Must add below dependencies
    implementation "androidx.camera:camera-core:1.2.0-alpha02"
    implementation "androidx.camera:camera-lifecycle:1.2.0-alpha02"
    implementation 'androidx.camera:camera-view:1.2.0-alpha02'
    implementation "androidx.camera:camera-camera2:1.2.0-alpha02"
}
```

## 2. Camera API

In layout file:

```xml

<com.kiri.sdk.camerakit.view.CameraView android:id="@+id/camera_view"
    android:layout_width="match_parent" android:layout_height="match_parent" />
```

Kotlin API:

```Kotlin
// Init camera and preview
cameraView.bind(LifecycleOwner)

// Set Photo save path
cameraView.setSavePath(File)

// Set take state callback
cameraView.setTakePictureListener(object : OnTakePictureListener {
    override fun onTaken(photoFile: File) {
        Log.e(TAG, "Taken a photo, save as: ${photoFile.absolutePath}")
    }

    override fun onTakeError(exception: Exception) {
        Log.e(TAG, "Taken error, error: ${exception.message}")
    }
})

// Take picture
cameraView.takePicture()
```

Method:

| Method name | Definition |
| ----- | ----- |
| bind | Initialize camera and preview |
| setSavePath | Set the path of captured photos. |
| setTakePictureListener | Set capturing photo related callback |
| takePicture | Taking photos |

<br/>

OnTakePictureListener declaration:

| Return type | Function signiture | Definition |
| ----- | ----- | ----- |
| void | onTaken(photoFile: File) | Capture one photo succesfully, will return the captured photo |
| void | onTakeError(exception: Exception) | Capture one photo failed, will return the error message |


⚠️ Note：You have to ask the camera permission youself

## 3. Code examples

#### activity_main.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<androidx.constraintlayout.widget.ConstraintLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto"
    xmlns:tools="http://schemas.android.com/tools" android:layout_width="match_parent"
    android:layout_height="match_parent" tools:context=".MainActivity">

    <com.kiri.sdk.camerakit.view.CameraView android:id="@+id/camera_view"
        android:layout_width="match_parent" android:layout_height="match_parent" />

    <androidx.appcompat.widget.AppCompatButton android:id="@+id/btn_taken"
        android:layout_width="wrap_content" android:layout_height="wrap_content"
        android:layout_marginBottom="30dp" android:text="@string/take_photo_text"
        app:layout_constraintBottom_toBottomOf="parent" app:layout_constraintEnd_toEndOf="parent"
        app:layout_constraintStart_toStartOf="parent" />

</androidx.constraintlayout.widget.ConstraintLayout>
```

#### MainActivity.kt

```Kotlin
package com.kiri.sdk.samples.basic.camera.demo

import android.Manifest
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import com.kiri.sdk.camerakit.view.OnTakePictureListener
import com.kiri.sdk.samples.basic.camera.demo.databinding.ActivityMainBinding
import com.tbruyelle.rxpermissions3.RxPermissions
import java.io.File
import java.lang.Exception


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
                binding.cameraView.bind(this)
            }
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
    }

}
```

<br/>

Chinese version: [中文版本](README_Chinese.md)
