# CameraKit RecordVideo Android Usage

## Version description:

| Library name                 | Latest version                                                                       |
|---------------------|--------------------------------------------------------------------------------------|
| CameraKit           | <img alt="Maven Central" src="https://img.shields.io/badge/KIRI--maven-1.2.0-green"> |

<br/>

## 1. Integrate into the project

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

Method:

| Method name                               | Definition                                                                                                                  |
|------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| bind                               | Initialize camera and preview, The parameter is a LifecycleOwner object, which will be automatically bound to the lifecycle |
| setSavePath                        | Set the path of captured videos, The parameter is a File object                                                                                |
| setMaxRecordTime                   | Set the maximum recording duration, in seconds, with a minimum of 3 seconds and a maximum of 120 seconds. It is mutually exclusive with MinRecordTime, and the minimum cannot be less than the minimum recording duration                                                  |
| setMinRecordTime                   | Set the minimum recording duration, in seconds, with a minimum of 3 seconds and a maximum that cannot exceed the maximum recording duration                                                                                      |
| setOnRecordTimeChange(second: Int) | Used to listen to the current recording duration, in seconds, during the recording process                                                                                                      |
| startRecord                        | Start recording operation                                                                                                                      |
| stopRecord                         | Stop recording operation                                                                                                                      |

⚠️ Note：You have to ask the camera permission youself

<br/>

## 3. Code examples

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

Chinese version: [中文版本](README_Chinese.md)