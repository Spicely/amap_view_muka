package com.muka.amap_view_muka

import android.app.Activity
import android.text.TextUtils
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.MapsInitializer
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/** AmapViewMukaPlugin */
class AmapViewMukaPlugin : FlutterPlugin, ActivityAware, MethodChannel.MethodCallHandler {

    private lateinit var activity: Activity

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    private var channel: MethodChannel? = null

    companion object {
        const val TAG_FLUTTER_FRAGMENT = "plugins.muka.com/amap_view_muka"
        const val AMAP_MUKA_MARKER = "plugins.muka.com/amap_view_muka_marker"
        const val AMAP_MUKA_SERVER = "plugins.muka.com/amap_view_muka_server"
        const val AMAP_MUKA_NAVI = "plugins.muka.com/amap_navi_view_muka"
        const val AMAP_MUKA_NAVI_CONTROLLER = "plugins.muka.com/amap_navi_view_muka_controller"
        const val AMAP_MUKA_NAVI_EVENT = "plugins.muka.com/amap_view_muka_event"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            TAG_FLUTTER_FRAGMENT,
            AmapViewFactory(activity, flutterPluginBinding)
        )
        flutterPluginBinding.platformViewRegistry.registerViewFactory(
            AMAP_MUKA_NAVI,
            AmapNaviViewFactory(activity, flutterPluginBinding)
        )

        channel =
            MethodChannel(flutterPluginBinding.binaryMessenger, AMAP_MUKA_SERVER)
        channel!!.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "setApiKey" -> {
                setApiKey(call.arguments as Map<*, *>)
                result.success(null)
            }
            "updatePrivacyShow" -> {
                val hasContains: Boolean = call.argument("hasContains")!!
                val hasShow: Boolean = call.argument("hasShow")!!
                MapsInitializer.updatePrivacyShow(activity, hasContains, hasShow)
                result.success(null)
            }
            "updatePrivacyAgree" -> {
                val hasAgree: Boolean = call.argument("hasAgree")!!
                MapsInitializer.updatePrivacyAgree(activity, hasAgree)
                result.success(null)
            }
            "fetch" -> {
                var mode: Any? = call.argument("mode")
                var locationClient = AMapLocationClient(flutterPluginBinding.applicationContext)
                var locationOption = AMapLocationClientOption()
                locationOption.locationMode = when (mode) {
                    1 -> AMapLocationClientOption.AMapLocationMode.Battery_Saving
                    2 -> AMapLocationClientOption.AMapLocationMode.Device_Sensors
                    else -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
                }
                locationClient.setLocationOption(locationOption)
                locationClient.setLocationListener {
                    if (it != null) {
                        if (it.errorCode == 0) {
                            result.success(Convert.toJson(it))
                        } else {
                            result.error(
                                "AmapError",
                                "onLocationChanged Error: ${it.errorInfo}",
                                it.errorInfo
                            )
                        }
                    }
                    locationClient.stopLocation()
                }
                locationClient.startLocation()
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

    /**
     * 设置apikey
     *
     * @param apiKeyMap
     */
    private fun setApiKey(apiKeyMap: Map<*, *>?) {
        if (null != apiKeyMap) {
            if (apiKeyMap.containsKey("android")
                && !TextUtils.isEmpty(apiKeyMap["android"] as String?)
            ) {
                MapsInitializer.setApiKey(apiKeyMap["android"] as String?)
            }
        }
    }

}
