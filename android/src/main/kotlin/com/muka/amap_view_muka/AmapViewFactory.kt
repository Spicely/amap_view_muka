package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.AssetManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.location.Location
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import androidx.core.app.ActivityCompat
import com.amap.api.maps.AMap
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.*
import com.amap.api.maps.offlinemap.OfflineMapActivity
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.AMAP_MUKA_MARKER
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException
import java.text.SimpleDateFormat
import java.util.*


class AmapViewFactory(
    private val activity: Activity,
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
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
        val params = args as Map<String, Any>
        return AMapView(context!!, viewId, flutterPluginBinding, params)
    }
}

class AMapView(
    private val context: Context,
    private val id: Int,
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val params:  Map<String, Any>
) : PlatformView,
    MethodChannel.MethodCallHandler,
    AMap.InfoWindowAdapter,
    AMap.OnMarkerClickListener,
    AMap.OnMapClickListener,
    AMap.OnCameraChangeListener,
    AMap.OnMyLocationChangeListener,
    AMap.OnMapScreenShotListener,
    AMap.OnMarkerDragListener {
    private val mapView: TextureMapView = TextureMapView(context)

    private var map: AMap = mapView.map

    private val methodChannel: MethodChannel

    private var markerController: MarkerController

    private var resultSkip: MethodChannel.Result? = null

    private var cropOpts: Map<String, Any>? = null

    init {
        mapView.onCreate(null)
//        map.setOnMapLoadedListener(this)
//
////        registrarActivityHashCode = registrar.activity().hashCode()

        // marker控制器
        methodChannel =
            MethodChannel(flutterPluginBinding.binaryMessenger, "${AMAP_MUKA_MARKER}_$id")
        methodChannel.setMethodCallHandler(this)

        markerController = MarkerController(methodChannel, map)

        Convert.initParams(params, map, context)

        (params["markers"] as List<*>?)?.forEach {
            markerController.addMarker(it as Map<String, Any>, context)
        }

        // 地图点击事件监听
        map.setOnMapClickListener(this)
        // 地图移动事件监听
        map.setOnCameraChangeListener(this)
        /// marker点击事件
        map.setOnMarkerClickListener(this)
        /// marker拖拽事件
        map.setOnMarkerDragListener(this)
        /// 定位蓝点
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
                markerController.addMarker(call.arguments as Map<String, Any>, context)
                result.success(true)
            }
            "marker#update" -> {
                markerController.updateMarker(call.arguments as Map<String, Any>, context, result)
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
                    myLocationStyle.anchor(
                        (anchor["u"] as Double).toFloat(),
                        (anchor["v"] as Double).toFloat()
                    )
                }

                if (strokeColor != null) {
                    myLocationStyle.strokeColor(
                        Color.rgb(
                            strokeColor[0],
                            strokeColor[1],
                            strokeColor[2]
                        )
                    )
                }

                if (radiusFillColor != null) {
                    myLocationStyle.radiusFillColor(
                        Color.rgb(
                            radiusFillColor[0],
                            radiusFillColor[1],
                            radiusFillColor[2]
                        )
                    )
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
                            val params =
                                    ViewGroup.LayoutParams((size["width"] as Double).toInt(), (size["height"] as Double).toInt())
                            val assetManager: AssetManager = context.assets
                            imageView.setImageBitmap(
                                BitmapFactory.decodeStream(
                                    assetManager.open(
                                        Convert.getFlutterAsset(
                                            icon["url"] as String,
                                            icon["package"] as String?
                                        )
                                    )
                                )
                            )
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
            "setCameraPosition" -> {
                Convert.initParams(call.arguments as Map<String, Any>, map, context)
                result.success(true)
            }
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
                flutterPluginBinding.applicationContext.startActivity(
                    Intent(
                        context,
                        OfflineMapActivity::class.java
                    ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                )
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
                val texturePath = opts["texturePath"] as String?
                val packageName = opts["package"] as String?
                val options = CustomMapStyleOptions()
                    .setEnable(true)
                    .setStyleId(styleId)
                if (texturePath != null) {
                    options.styleTexturePath = Convert.getFlutterAsset(texturePath, packageName)
                }
                map.setCustomMapStyle(options);
                result.success(true)
            }
            "setZoomControlsEnabled" -> {
                /// 缩放按钮
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isZoomControlsEnabled = enabled
                result.success(true)
            }
            "setCompassEnabled" -> {
                /// 指南针
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isCompassEnabled = enabled
                result.success(true)
            }
            "setMyLocationButtonEnabled" -> {
                /// 定位按钮
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isMyLocationButtonEnabled = enabled
                result.success(true)
            }
            "setLogoPosition" -> {
                /// 地图Logo位置
                val opts = call.arguments as Map<String, Any>
                when ((opts["position"] as Int?)!!) {
                    1 -> {
                        map.uiSettings.logoPosition = AMapOptions.LOGO_MARGIN_BOTTOM
                    }
                    2 -> {
                        map.uiSettings.logoPosition = AMapOptions.LOGO_MARGIN_RIGHT
                    }
                    3 -> {
                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_CENTER
                    }
                    4 -> {
                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_RIGHT
                    }
                    else -> {
                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_LEFT
                    }
                }
                result.success(true)
            }
            "setZoomGesturesEnabled" -> {
                /// 缩放手势
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isZoomGesturesEnabled = enabled
                result.success(true)
            }
            "setScrollGesturesEnabled" -> {
                /// 滑动手势
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isScrollGesturesEnabled = enabled
                result.success(true)
            }
            "setRotateGesturesEnabled" -> {
                /// 旋转手势
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isRotateGesturesEnabled = enabled
                result.success(true)
            }
            "setTiltGesturesEnabled" -> {
                /// 倾斜手势
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isTiltGesturesEnabled = enabled
                result.success(true)
            }
            "setAllGesturesEnabled" -> {
                /// 所有手势
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.setAllGesturesEnabled(enabled)
                result.success(true)
            }
            "getZoomGesturesEnabled" -> {
                result.success(map.uiSettings.isZoomGesturesEnabled)
            }
            "getScrollGesturesEnabled" -> {
                result.success(map.uiSettings.isScrollGesturesEnabled)
            }
            "getRotateGesturesEnabled" -> {
                result.success(map.uiSettings.isRotateGesturesEnabled)
            }
            "getTiltGesturesEnabled" -> {
                result.success(map.uiSettings.isTiltGesturesEnabled)
            }
            "setGestureScaleByMapCenter" -> {
                val opts = call.arguments as Map<String, Any>
                val enabled = (opts["enabled"] as Boolean?)!!
                map.uiSettings.isGestureScaleByMapCenter = enabled
                result.success(true)
            }
            "setPointToCenter" -> {
                val opts = call.arguments as Map<String, Any>
                val x = (opts["x"] as Int?)!!
                val y = (opts["y"] as Int?)!!
                map.setPointToCenter(x, y)
                result.success(true)
            }
            "animateCamera" -> {
                val opts = call.arguments as Map<String, Any>

                val cameraPosition = (opts["cameraPosition"] as Map<String, Any>?)!!
                val latLng = (cameraPosition["latLng"] as Map<String, Any>?)!!
                val zoom = (cameraPosition["zoom"] as Double?)!!
                val tilt = (cameraPosition["tilt"] as Double?)!!
                val bearing = (cameraPosition["bearing"] as Double?)!!
                val duration = cameraPosition["duration"] as Int?
                val mCameraUpdate = CameraUpdateFactory.newCameraPosition(
                    CameraPosition(
                        LatLng(
                            latLng["latitude"] as Double,
                            latLng["longitude"] as Double
                        ), zoom.toFloat(), tilt.toFloat(), bearing.toFloat()
                    )
                )
                if (duration == null) {
                    map.moveCamera(mCameraUpdate)
                } else {
                    map.animateCamera(mCameraUpdate, duration.toLong(), null)
                }
                result.success(true)
            }
            "setMapStatusLimits" -> {
                val opts = call.arguments as Map<String, Any>
                val southwestLatLng = (opts["southwestLatLng"] as Map<String, Any>?)!!
                val northeastLatLng = (opts["northeastLatLng"] as Map<String, Any>?)!!
                val latLngBounds = LatLngBounds(
                    LatLng(
                        southwestLatLng["latitude"] as Double,
                        southwestLatLng["longitude"] as Double
                    ), LatLng(
                        northeastLatLng["latitude"] as Double,
                        northeastLatLng["longitude"] as Double
                    )
                )
                map.setMapStatusLimits(latLngBounds)
                result.success(true)
            }
            "getMapScreenShot" -> {
                val opts = call.arguments as Map<String, Any>
                cropOpts = (opts["shot"] as Map<String, Any>?)!!
                map.getMapScreenShot(this)
                resultSkip = result
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

    override fun onMapScreenShot(bitmap: Bitmap) {
    }

    override fun onMapScreenShot(bitmap: Bitmap, status: Int) {
        val sdf = SimpleDateFormat("yyyyMMddHHmmss")
        if (null == bitmap) {
            resultSkip?.error("400", "null", status)
            return
        }
        try {
            Log.d("ssa",cropOpts.toString());
           val newImag = Bitmap.createBitmap(bitmap, (cropOpts?.get("x") as Double).toInt(), (cropOpts?.get("y") as Double).toInt(), (cropOpts?.get("width") as Double).toInt(), (cropOpts?.get("height") as Double).toInt())
            val path =
                context.getExternalFilesDir(null).toString() + "/map_" + sdf.format(Date()) + ".png"
            val fos = FileOutputStream(path)
            newImag.compress(Bitmap.CompressFormat.PNG, (cropOpts?.get("compressionQuality") as Double * 100).toInt(), fos)
            try {
                fos.flush()
            } catch (e: IOException) {
                resultSkip?.error("400", e.printStackTrace().toString(), status)
            }
            try {
                fos.close()
            } catch (e: IOException) {
                e.printStackTrace()
            }
            resultSkip?.success(path)
        } catch (e: FileNotFoundException) {
            resultSkip?.error("400", e.printStackTrace().toString(), status)
        }
    }

    override fun onMapClick(point: LatLng) {
        val arguments = HashMap<String, Any>()
        val latLng = HashMap<String, Any>()
        latLng["latitude"] = point.latitude
        latLng["longitude"] = point.longitude
        arguments["latLng"] = latLng
        arguments["zoom"] = map.cameraPosition.zoom
        arguments["tilt"] = map.cameraPosition.tilt.toDouble()
        arguments["bearing"] = map.cameraPosition.bearing.toDouble()
        arguments["duration"] = 0
        methodChannel.invokeMethod("map#onMapClick", arguments)
    }

    override fun onCameraChange(position: CameraPosition) {
        var arguments = Convert.toJson(position)
        methodChannel.invokeMethod("map#onMapMove", arguments)
    }

    override fun onCameraChangeFinish(position: CameraPosition) {
        var arguments = Convert.toJson(position)
        methodChannel.invokeMethod("map#onMapIdle", arguments)
    }


}
