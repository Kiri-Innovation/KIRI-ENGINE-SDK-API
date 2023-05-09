package com.kiri.sdk.samples.basic.camera.demo

import android.app.Application
import com.kiri.sdk.basic.authentication.*

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