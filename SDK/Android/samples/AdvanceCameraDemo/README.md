# AdvanceCameraKit Android Usage

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
<com.kiri.advance.camera.toolkit.view.CameraView
        android:id="@+id/camera_view"
        android:layout_width="match_parent"
        android:layout_height="match_parent" />
```


KT code API:

```Kotlin
// Initialize camera and preview 
cameraView.bind(LifecycleOwner)

// Get the adjustable range of ev (exposure value), iso, ss (shutter speed)
cameraView.advAdjustInfo

// Adjustable range of ev, type: List<ParamsEntity>
cameraView.advAdjustInfo?.ev

// Adjustable range of iso, type: List<ParamsEntity>
cameraView.advAdjustInfo?.iso

// Adjustable range of ss, type: List<ParamsEntity>
cameraView.advAdjustInfo?.ss

// Set Listener of the ev, iso, ss value change in camera preview page
cameraView.setOnPreviewAdvParamsChange(OnPreviewAdvParamsChangeListener)

// Set ev value of the camera
cameraView.controlEV(ParamsEntity)

// Set iso value of the camera
cameraView.controlISO(ParamsEntity)

// Set ss value of the camera
cameraView.controlSS(ParamsEntity)

// Reset ev, iso, ss value of the camera
cameraView.resetAdv()

// Change the test exposure mode. Available mode:  CameraAdvanceMode.Auto (Auto change exposure), CameraAdvanceMode.Manual (Manually change exposure)
cameraView.changeAdvMode(CameraAdvanceMode)

// Get the test exposure mode. Default: CameraAdvanceMode.Auto (Auto change exposure)
cameraView.advMode

// Set the path of captured photos.
cameraView.setSavePath(File)

// Set capturing photo related callback 
cameraView.setTakePictureListener(object : OnTakePictureListener {
    override fun onTaken(photoFile: File) {
        Log.e(TAG, "Took one photo, saved in: ${photoFile.absolutePath}")
    }

    override fun onTakeError(exception: Exception) {
        Log.e(TAG, "Error in taking photo, error message is: ${exception.message}")
    }
})

// Taking photos.
cameraView.takePicture()
```

Method:

| Method name | Definition |
| ----- | ----- |
| bind | Initialize camera and preview |
| setSavePath | Set the path of captured photos. |
| setTakePictureListener | Set capturing photo related callback |
| takePicture | Taking photos |
| setOnPreviewAdvParamsChange | Set Listener of the ev, iso, ss value change in camera preview page |
| controlEV | Set ev value of the camera |
| controlISO | Set iso value of the camera |
| controlSS | Set ss value of the camera |
| resetAdv | Reset ev, iso, ss value of the camera |


<br/>

OnTakePictureListener declaration:

| Return type | Function signiture | Definition |
| ----- | ----- | ----- |
| void | onTaken(photoFile: File) | Capture one photo succesfully, will return the captured photo |
| void | onTakeError(exception: Exception) | Capture one photo failed, will return the error message |

<br/>

ParamsEntity declaration:

| Variable type | Variable name | Description |
| ----- | ----- | ----- |
| String | formatStr | String of the value to display on UI |
| Float | value |  Real value to pass to the camera |
| Int | step | Steps between two level of the value, its only for UI purpose |
| Int | index | Index of the current value in the range list |

| Return type | Function signiture | Definition |
| ----- | ----- | ----- |
| Boolean | isEmpty() | Check if current variable is empty, Definition: formatStr is empty String & value = -1 & step = -1 & index = -1 |

<br/>

OnPreviewAdvParamsChangeListener declaration:

| Return type | Function signiture | Definition |
| ----- | ----- | ----- |
| void | onPreviewAdvParamsChanged(previewParams: PreviewAdvParams) | This function will be calledback when current camera has ev, iso, or ss value change |

<br/>

PreviewAdvParams declaration:

| Variable type | Variable name | Description |
| ----- | ----- | ----- |
| ParamsEntity | iso | iso value of the camera |
| ParamsEntity | ss | ss value of the camera |
| ParamsEntity | ev | ev value of the camera |

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

<br/>

Chinese version: [中文版本](README_Chinese.md)
