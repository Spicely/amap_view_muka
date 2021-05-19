package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.location.Location
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat.startActivity
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.amap.api.maps.model.CustomMapStyleOptions
import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.MyLocationStyle
import com.amap.api.maps.offlinemap.OfflineMapActivity
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.AMAP_MUKA_MARKER
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class AmapViewFactory(
        private val activity: Activity,
        private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("11111111111", "221111111111111111")
        // 申请权限
        ActivityCompat.requestPermissions(
                activity,
                arrayOf(
                        Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.READ_PHONE_STATE
                ),
                321
        )
        Log.d("11111111111", "221144444444444444411111111111111")
        val params = args as Map<*, *>
//        var opts = Convert.toUnifiedMapOptions(params["options"])
        var initialMarkers = params["markers"]
        println(initialMarkers)
        return AMapView(context, viewId, flutterPluginBinding, initialMarkers)
    }
}

class AMapView(
        private val context: Context,
        private val id: Int,
        private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
        private val initialMarkers: Any?
) : PlatformView,
        MethodChannel.MethodCallHandler,
        AMap.InfoWindowAdapter,
        AMap.OnMarkerClickListener,
        AMap.OnMyLocationChangeListener,
        AMap.OnMarkerDragListener {
    private val mapView: TextureMapView = TextureMapView(context)

    private var map: AMap = mapView.map

    private val methodChannel: MethodChannel

    private var markerController: MarkerController

    init {
        mapView.onCreate(null)
//        map.setOnMapLoadedListener(this)
//
////        registrarActivityHashCode = registrar.activity().hashCode()
//
        // marker控制器
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "${AMAP_MUKA_MARKER}_$id")
        methodChannel.setMethodCallHandler(this)

        markerController = MarkerController(methodChannel, map)

        map.setOnMarkerClickListener(this)
        map.setOnMarkerDragListener(this)
        map.setOnMyLocationChangeListener(this)


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
                markerController.addMarker(call.arguments as Map<String, Any>, context, result)
            }
            "marker#delete" -> {
                markerController.deleteMarker(call.arguments as Map<String, Any>, result)
            }
            "enabledMyLocation" -> {
                val opts = call.arguments as Map<String, Any>
                val locationStyle = (opts["locationStyle"] as Int?)!!
                val interval = (opts["interval"] as Int?)!!
                val enabled = (opts["enabled"] as Boolean?)!!
                val myLocationStyle = MyLocationStyle()
                val icon: Map<String, Any>? = (opts["icon"] as Map<String, Any>?)
                val anchor: Map<String, Any>? = (opts["anchor"] as Map<String, Any>?)
                val strokeColor = opts["strokeColor"] as List<Int>?
                val radiusFillColor = opts["radiusFillColor"] as List<Int>?
                val strokeWidth = opts["strokeWidth"] as Double?

                if (anchor != null) {
                    myLocationStyle.anchor((anchor["u"] as Double).toFloat(), (anchor["v"] as Double).toFloat())
                }

                if (strokeColor != null) {
                    myLocationStyle.strokeColor(Color.rgb(strokeColor[0], strokeColor[1], strokeColor[2]))
                }

                if (radiusFillColor != null) {
                    myLocationStyle.radiusFillColor(Color.rgb(radiusFillColor[0], radiusFillColor[1], radiusFillColor[2]))
                }

                if (strokeWidth != null) {
                    myLocationStyle.strokeWidth(strokeWidth.toFloat())
                }

                when (locationStyle) {
                    1 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE)
                    }
                    2 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW)
                    }
                    3 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_MAP_ROTATE)
                    }
                    4 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE)
                    }
                    5 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER)
                    }
                    6 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW_NO_CENTER)
                    }
                    7 -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_MAP_ROTATE_NO_CENTER)
                    }
                    else -> {
                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_SHOW)
                    }
                }

                myLocationStyle.interval(interval.toLong())
                myLocationStyle.showMyLocation(enabled)
                if (icon != null) {
                    when (icon["type"]) {
                        "marker#asset" -> {
                            val size = icon["size"] as Map<String, Any>
                            val imageView = ImageView(context)
                            val params = ViewGroup.LayoutParams(size["width"] as Int, size["height"] as Int)
                            val assetManager: AssetManager = context.assets
                            imageView.setImageBitmap(BitmapFactory.decodeStream(assetManager.open(Convert.getFlutterAsset(icon["url"] as String, icon["package"] as String?))))
                            imageView.layoutParams = params
                            val asset = BitmapDescriptorFactory.fromView(imageView)
                            myLocationStyle.myLocationIcon(asset)
                        }
                        "marker#web" -> {

                        }
                    }
                }
                map.myLocationStyle = myLocationStyle
                map.isMyLocationEnabled = true
                result.success(true)
            }
            "disbleMyLocation" -> {
                map.isMyLocationEnabled = false
                result.success(true)
            }
            "setZoomLevel" -> {
                val opts = call.arguments as Map<String, Any>
                val level = (opts["level"] as Double?)!!
                map.moveCamera(CameraUpdateFactory.zoomTo(level.toFloat()))
                result.success(true)
            }
            "setIndoorMap" -> {
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.showIndoorMap(enabled)
                result.success(true)
            }
//            "setLocatingPosition" -> {
//                val opts = call.arguments as Map<String, Any>
//                val latLng = (opts["latLng"] as Map<String, Any>?)!!
//                map
//                result.success(true)
//            }
            "setMapType" -> {
                val opts = call.arguments as Map<String, Any>
                when ((opts["type"] as Int?)!!) {
                    0 -> {
                        map.mapType = AMap.MAP_TYPE_NAVI
                    }
                    1 -> {
                        map.mapType = AMap.MAP_TYPE_NIGHT
                    }
                    3 -> {
                        map.mapType = AMap.MAP_TYPE_SATELLITE
                    }
                    else -> {
                        map.mapType = AMap.MAP_TYPE_NORMAL
                    }

                }
                result.success(true)
            }
            "setMapLanguage" -> {
                val opts = call.arguments as Map<String, Any>
                when ((opts["language"] as Int?)!!) {
                    1 -> {
                        map.setMapLanguage(AMap.ENGLISH)
                    }
                    else -> {
                        map.setMapLanguage(AMap.CHINESE)
                    }
                }
                result.success(true)
            }
            "openOfflineMap" -> {
                /// 打开离线地图
                flutterPluginBinding.applicationContext.startActivity(Intent(context, OfflineMapActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                result.success(true)
            }
            "setOffLineCustomMapStyle" -> {
                /// 设置离线自定义地图
                val opts = call.arguments as Map<String, Any>
                val dataPath = (opts["dataPath"] as String?)!!
                val extraPath = (opts["extraPath"] as String?)!!
                val texturePath = opts["texturePath"] as String?
                val packageName = opts["package"] as String?
                val options = CustomMapStyleOptions()
                        .setEnable(true)
                        .setStyleDataPath(Convert.getFlutterAsset(dataPath, packageName))
                        .setStyleExtraPath(Convert.getFlutterAsset(extraPath, packageName))
                if (texturePath != null) {
                    options.styleTexturePath = Convert.getFlutterAsset(texturePath, packageName)
                }
                map.setCustomMapStyle(options);
                result.success(true)
            }
            "setOnLineCustomMapStyle" -> {
                /// 设置在线自定义地图
                val opts = call.arguments as Map<String, Any>
                val styleId = (opts["styleId"] as String?)!!
                val options = CustomMapStyleOptions()
                    .setEnable(true)
                    .setStyleId(styleId)
                map.setCustomMapStyle(options);
                result.success(true)
            }
        }
    }

    /// marker点击处理
    override fun onMarkerClick(marker: Marker): Boolean {
        return markerController.onClick(marker)
    }

    /// marker开始移动
    override fun onMarkerDragStart(marker: Marker) {
        markerController.onDrag(marker, "marker#onDragStart")
    }

    /// marker移动中
    override fun onMarkerDrag(marker: Marker) {
        markerController.onDrag(marker, "marker#onDragMove")
    }

    /// marker移动结束
    override fun onMarkerDragEnd(marker: Marker) {
        markerController.onDrag(marker, "marker#onDragEnd")
    }

    override fun getInfoWindow(marker: Marker): View? {
        return markerController.getInfoWindow(marker)
    }

    override fun getInfoContents(p0: Marker?): View {
        TODO("Not yet implemented")
    }


    override fun onMyLocationChange(it: Location) {
//        Log.e("高德地图", "onMyLocationChange: 定位失败");
    }


}
