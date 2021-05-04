package com.muka.amap_view_muka

import android.app.Activity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** AmapViewMukaPlugin */
class AmapViewMukaPlugin: FlutterPlugin, ActivityAware {

  private lateinit var activity: Activity

  private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

  companion object {
    const val TAG_FLUTTER_FRAGMENT = "plugins.muka.com/amap_view_muka"
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    this.flutterPluginBinding = flutterPluginBinding
  }


  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    flutterPluginBinding.platformViewRegistry.registerViewFactory(TAG_FLUTTER_FRAGMENT, AmapViewFactory(flutterPluginBinding))
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {
    TODO("Not yet implemented")
  }
}
