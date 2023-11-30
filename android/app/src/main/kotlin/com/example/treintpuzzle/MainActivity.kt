package com.example.treintpuzzle

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.view.View
import android.view.WindowManager

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)

        window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                                or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
                                                or View.SYSTEM_UI_FLAG_FULLSCREEN)
    }
}
