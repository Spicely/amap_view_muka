package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import androidx.core.app.ActivityCompat
import com.amap.api.maps.AMap
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.MarkerOptions
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.AMAP_MUKA_MARKER
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class AmapViewFactory(private val activity: Activity, private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("11111111111", "221111111111111111")
        // 申请权限
        ActivityCompat.requestPermissions(activity,
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.READ_PHONE_STATE),
                321
        )
        Log.d("11111111111", "221144444444444444411111111111111")
        val params = args as Map<String, Any>
//        var opts = Convert.toUnifiedMapOptions(params["options"])
        var initialMarkers = params["markers"]
        println(initialMarkers)
        return AMapView(context, viewId, flutterPluginBinding, initialMarkers)
    }
}

class AMapView(context: Context, id: Int, private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, private val initialMarkers: Any?) : PlatformView, MethodChannel.MethodCallHandler {
    private val mapView: TextureMapView = TextureMapView(context)

    private var map: AMap = mapView.map

    private val methodChannel: MethodChannel

    private val markers = HashMap<String, MarkerOptions>()

    init {
        mapView.onCreate(null)
//        map.setOnMapLoadedListener(this)
//
////        registrarActivityHashCode = registrar.activity().hashCode()
//
        // marker控制器
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "${AMAP_MUKA_MARKER}_$id")
        methodChannel.setMethodCallHandler(this)

//
//        // polyline控制器
//        polylineController = PolylineController(methodChannel, mapView.map)
    }

    override fun getView(): View {
        return mapView
    }


    override fun dispose() {
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "marker#add" -> {
                var type: String = call.argument("type")!!
                var id: String = call.argument("id")!!
                var position: Map<String, Any> = call.argument("position")!!
                when (type) {
                    "defaultMarker" -> {
                        val latLng = LatLng(position["latitude"] as Double, position["longitude"] as Double)
                        var title: String? = call.argument("title")
                        var snippet: String? = call.argument("snippet")
//                        var anchor: String? = call.argument("anchor")
                        var visible: Boolean = call.argument("visible")!!
                        var draggable: Boolean = call.argument("draggable")!!
                        var alpha: Float = call.argument<Double>("alpha")!!.toFloat()
                        markers[id] = MarkerOptions()
                        markers[id]?.position(latLng)?.visible(visible)?.draggable(draggable)?.alpha(alpha)
                        if (title != null) {
                            markers[id]?.title(title)
                        }
                        if (snippet != null) {
                            markers[id]?.snippet(snippet)
                        }
                        map.addMarker(markers[id])
                        result.success(true)
                    }
                }
            }
        }
    }


}
