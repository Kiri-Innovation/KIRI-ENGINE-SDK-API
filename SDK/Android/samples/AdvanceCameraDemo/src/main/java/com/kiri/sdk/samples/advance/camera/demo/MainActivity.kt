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