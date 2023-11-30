package com.example.treintpuzzle

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import android.view.View

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }

    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            window.decorView.systemUiVisibility = (View.SYSTEM_UI_FLAG_FULLSCREEN
                                                    or View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                                                    or View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                                                    or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                                                    or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                                                    or View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY)
        }
    }
}
