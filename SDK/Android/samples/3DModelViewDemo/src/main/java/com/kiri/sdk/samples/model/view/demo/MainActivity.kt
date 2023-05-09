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