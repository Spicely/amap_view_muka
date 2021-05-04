package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import androidx.core.app.ActivityCompat
import com.amap.api.maps.AMap
import com.amap.api.maps.TextureMapView
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.TAG_FLUTTER_FRAGMENT
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class AmapViewFactory(private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("11111111111", "221111111111111111")
        // 申请权限
//        ActivityCompat.requestPermissions(activity,
//                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
//                        Manifest.permission.ACCESS_FINE_LOCATION,
//                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
//                        Manifest.permission.READ_EXTERNAL_STORAGE,
//                        Manifest.permission.READ_PHONE_STATE),
//                321
//        )
        Log.d("11111111111", "221144444444444444411111111111111")
        val params = args as Map<String, Any>
//        var opts = Convert.toUnifiedMapOptions(params["options"])
        var initialMarkers = params["markers"]
        println(initialMarkers)
        return AMapView(context, viewId, flutterPluginBinding, initialMarkers)
    }
}

class AMapView(context: Context, id: Int, private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, private val initialMarkers: Any?) : PlatformView {
    private val mapView: TextureMapView = TextureMapView(context)

    private var map: AMap = mapView.map

    private val methodChannel: MethodChannel

    init {
        mapView.onCreate(null)
//        map.setOnMapLoadedListener(this)
//
////        registrarActivityHashCode = registrar.activity().hashCode()
//
//        // 双端通信channel
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "$TAG_FLUTTER_FRAGMENT$id")
//        methodChannel.setMethodCallHandler(this)
//
//        // marker控制器
//        markerController = MarkerController(methodChannel, mapView.map)
//
//        // polyline控制器
//        polylineController = PolylineController(methodChannel, mapView.map)
    }

    override fun getView(): View {
        return mapView
    }


    override fun dispose() {
    }
}
