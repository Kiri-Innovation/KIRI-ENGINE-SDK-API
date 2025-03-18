package com.kiri.sdk.samples.basic.camera.record.demo

import android.Manifest
import android.content.Intent
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

    private var isRecording = false

    /**  Init CameraRecord Function API  **/
    private fun initCameraRecord() {
        // Set Photo save path
        binding.recordView.setSavePath(mediaDir)

        binding.recordView.setMaxRecordTime(100)
        // binding.recordView.setMaxRecordTime(3)

        // Add RecordTime Change Listener
        binding.recordView.setOnRecordTimeChange { second: Int ->
            runOnUiThread {
                Log.e(TAG, "second -> $second")
            }
        }

        // Record video
        binding.btnRecord.setOnClickListener {
            if (isRecording) {
                isRecording = false
                binding.recordView.stopRecord()
            } else {
                isRecording = true
                Log.e(TAG, "Start Record!!!!")

                binding.recordView.startRecord(
                    onSaved = { file ->
                        Log.e(TAG, "Record success, file: ${file.absoluteFile}")
                        Log.e(TAG, "录制完毕开始跳转到页面二")
                        // 跳转到页面 2
//                        startActivity(Intent(this, SecondActivity::class.java))
                    },
                    onError = { e ->
                        Log.e(TAG, "Record error, error: ${e.message}")
                    }
                )
            }
        }
    }

}