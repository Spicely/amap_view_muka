package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.util.SparseArray
import android.view.View
import androidx.core.app.ActivityCompat
import com.amap.api.maps.model.MyLocationStyle
import com.amap.api.navi.AMapNavi
import com.amap.api.navi.AMapNaviListener
import com.amap.api.navi.AMapNaviView
import com.amap.api.navi.AMapNaviViewListener
import com.amap.api.navi.model.AMapCalcRouteResult
import com.amap.api.navi.model.AMapLaneInfo
import com.amap.api.navi.model.AMapModelCross
import com.amap.api.navi.model.AMapNaviCameraInfo
import com.amap.api.navi.model.AMapNaviCross
import com.amap.api.navi.model.AMapNaviLocation
import com.amap.api.navi.model.AMapNaviPath
import com.amap.api.navi.model.AMapNaviRouteNotifyData
import com.amap.api.navi.model.AMapNaviTrafficFacilityInfo
import com.amap.api.navi.model.AMapServiceAreaInfo
import com.amap.api.navi.model.AimLessModeCongestionInfo
import com.amap.api.navi.model.AimLessModeStat
import com.amap.api.navi.model.NaviInfo
import com.amap.api.navi.view.RouteOverLay
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class AMapNaviViewFactory(
    private val activity: Activity,
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        // 申请权限
        ActivityCompat.requestPermissions(
            activity, arrayOf(
                Manifest.permission.ACCESS_COARSE_LOCATION,
                Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.WRITE_EXTERNAL_STORAGE,
                Manifest.permission.READ_EXTERNAL_STORAGE,
                Manifest.permission.READ_PHONE_STATE
            ), 321
        )
        val params = args as Map<*, *>
        return AMapNaviView(context, viewId, flutterPluginBinding, params)
    }
}


class AMapNaviView(
    private val context: Context,
    private val id: Int,
    private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding,
    private val params: Map<*, *>
) : PlatformView, AMapNaviListener, AMapNaviViewListener, EventChannel.StreamHandler, MethodChannel.MethodCallHandler {


    private var mAMapNaviView: AMapNaviView = AMapNaviView(context, Convert.toAMapNaviViewOptions(params["viewOptions"] as Map<*, *>))

    private var mAMapNavi: AMapNavi

    private val methodChannel: MethodChannel

    private var eventSink: EventChannel.EventSink? = null

    private var eventChannel: EventChannel? = null

    private var resultSkip: MethodChannel.Result? = null

    private var cropOpts: Map<String, Any>? = null

    /**
     * 保存当前算好的路线
     */
    private val routeOverlays: SparseArray<RouteOverLay> = SparseArray<RouteOverLay>()

    init {
        mAMapNaviView.onCreate(null)
        mAMapNavi = AMapNavi.getInstance(context)

        // marker控制器
        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "${AmapViewMukaPlugin.AMAP_MUKA_NAVI_CONTROLLER}_$id")
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "${AmapViewMukaPlugin.AMAP_MUKA_NAVI_EVENT}_$id")
        mAMapNaviView.setAMapNaviViewListener(this)
        mAMapNavi.addAMapNaviListener(this)
        methodChannel.setMethodCallHandler(this)

//        val myLocationStyle = MyLocationStyle()
//        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE)
//        myLocationStyle.showMyLocation(true)

        Log.e("params", ": ${params.toMap().toString()}")


        /// 定位当前位置
//        if (params!=null && params["showMyLocation"] != null && params["showMyLocation"] as Boolean) {


//        }
    }


    override fun getView(): View {
        return mAMapNaviView
    }


    override fun dispose() {
        mAMapNaviView.setAMapNaviViewListener(null)
        methodChannel.setMethodCallHandler(null)
        mAMapNaviView.onDestroy()
        mAMapNavi.stopNavi()
        AMapNavi.destroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments as Map<*, *>
        when (call.method) {
            "setAMapNaviViewOptions" -> {
                val options = Convert.toAMapNaviViewOptions(args)
                mAMapNaviView.viewOptions = options
                result.success(null)
            }

            "setAMap" -> {
                Convert.setAMap(args, mAMapNaviView.map)
                result.success(null)
            }
        }
    }


    override fun onInitNaviFailure() {
        Log.d("onInitNaviFailure", "error")
    }

    override fun onInitNaviSuccess() {
        if (params != null) {
            Convert.initParams(params, mAMapNaviView, context)
        }
        Log.e("调试信息", "初始化完成");
        Log.e("调试信息", "计算导航路线");

        // 起点信息
//        var startLatLng =
//            Convert.toLatLng(((params["startToEnd"] as Map<*, *>)["start"] as Map<*, *>)["latLng"] as Map<*, *>?)
//        val start = NaviPoi(
//            ((params["startToEnd"] as Map<*, *>)["start"] as Map<*, *>)["address"] as String,
//            startLatLng,
//            ""
//        )
//        // 终点信息
//        var endLatLng =
//            Convert.toLatLng(((params["startToEnd"] as Map<*, *>)["end"] as Map<*, *>)["latLng"] as Map<*, *>?)
//        val end = NaviPoi(
//            ((params["startToEnd"] as Map<*, *>)["end"] as Map<*, *>)["address"] as String,
//            endLatLng,
//            ""
//        )
//        val carInfo = AMapCarInfo()
//        when (params["calculateType"] as Int) {
//            // 驾车/货车路线规划
//            0 -> {
//                carInfo.carType = "0"
//                mAMapNavi.setCarInfo(carInfo);
//                mAMapNavi.calculateDriveRoute(
//                    start,
//                    end,
//                    null,
//                    PathPlanningStrategy.DRIVING_MULTIPLE_ROUTES_DEFAULT
//                )
//            }
        // 骑行
//            1 -> {
//                mAMapNavi.independentCalculateRoute(
//                    start,
//                    end,
//                    null,
//                    PathPlanningStrategy.DRIVING_MULTIPLE_ROUTES_DEFAULT,
//                    2,
//                    this
//                )
//            }
//            // 骑行
//            2 -> {
//                mAMapNavi.independentCalculateRoute(
//                    start,
//                    end,
//                    null,
//                    PathPlanningStrategy.DRIVING_MULTIPLE_ROUTES_DEFAULT,
//                    3,
//                    this
//                )
//            }
//            // 摩托车
//            3 -> {
//                carInfo.carNumber = "京C123456" //设置车牌号
//                carInfo.carType = "11" //设置车辆类型,11代表摩托车
//                carInfo.motorcycleCC = 100 //设置摩托车排量
//                mAMapNavi.setCarInfo(carInfo);
//                mAMapNavi.independentCalculateRoute(
//                    start,
//                    end,
//                    null,
//                    PathPlanningStrategy.DRIVING_MULTIPLE_ROUTES_DEFAULT,
//                    1,
//                    this
//                )
//            }
        // 电动车
//            4 -> {
//                mAMapNavi.calculateEleBikeRoute(start, end, TravelStrategy.MULTIPLE);
//            }
//        }
    }

    override fun onStartNavi(p0: Int) {

    }

    override fun onTrafficStatusUpdate() {
    }

    override fun onLocationChange(loc: AMapNaviLocation?) {
//        aMapNaviView.map.setLocationSource(LocationSource())

//        Log.d("onLocationChange", loc.lo)
    }

    override fun onGetNavigationText(p0: Int, p1: String?) {

    }

    override fun onGetNavigationText(p0: String?) {

    }

    override fun onEndEmulatorNavi() {

    }

    override fun onArriveDestination() {

    }


    override fun onCalculateRouteFailure(p0: Int) {
        Log.d("onCalculateRouteFailure", "路径规划失败")
    }

    override fun onCalculateRouteFailure(p0: AMapCalcRouteResult?) {
        val data: MutableMap<String, Any?> = mutableMapOf()
        data["type"] = "calculateRouteFailure"
        data["data"] = p0.toString()
        eventSink?.success(data)
    }

    override fun onReCalculateRouteForYaw() {

    }

    override fun onReCalculateRouteForTrafficJam() {

    }

    override fun onArrivedWayPoint(p0: Int) {

    }

    override fun onGpsOpenStatus(p0: Boolean) {

    }

    override fun onNaviInfoUpdate(p0: NaviInfo?) {

    }

    override fun updateCameraInfo(p0: Array<out AMapNaviCameraInfo>?) {

    }

    override fun updateIntervalCameraInfo(
        p0: AMapNaviCameraInfo?, p1: AMapNaviCameraInfo?, p2: Int
    ) {

    }

    override fun onServiceAreaUpdate(p0: Array<out AMapServiceAreaInfo>?) {

    }

    override fun showCross(p0: AMapNaviCross?) {

    }

    override fun hideCross() {

    }

    override fun showModeCross(p0: AMapModelCross?) {

    }

    override fun hideModeCross() {

    }

    override fun showLaneInfo(p0: Array<out AMapLaneInfo>?, p1: ByteArray?, p2: ByteArray?) {

    }

    override fun showLaneInfo(p0: AMapLaneInfo?) {

    }

    override fun hideLaneInfo() {

    }


    override fun onCalculateRouteSuccess(p0: IntArray?) {
        Log.d("onCalculateRouteSuccess", "okArray")
//        mAMapNavi.startNavi(NaviType.GPS)
    }

    /// 路线规划成功
    override fun onCalculateRouteSuccess(routeResult: AMapCalcRouteResult?) {
//        if (routeResult != null) {
//            // 获取路线数据对象
//            val data: MutableMap<String, Any> = mutableMapOf()
//            var infos: MutableList<MutableMap<String, Any>> = mutableListOf()
//            data["type"] = "onCalculateRouteSuccess"
//            data["data"] = infos
//
//            routeOverlays.clear()
//
//            val routeIds: IntArray = routeResult.routeid
//            val paths = mAMapNavi.naviPaths
//            for (i in routeIds.indices) {
//                val path = paths[routeIds[i]]
//                if (path != null) {
//                    val info: MutableMap<String, Any> = mutableMapOf()
//                    info["allTime"] = path.allTime
//                    info["allLength"] = path.allLength
//                    info["allCameras"] =  path.allCameras.size
//                    infos.add(info)
//                    drawRoutes(routeIds[i], path)
//                }
//            }
//            eventSink?.success(data)
//        }
//        mAMapNavi.startNavi(NaviType.GPS)
    }

    override fun notifyParallelRoad(p0: Int) {

    }

    override fun OnUpdateTrafficFacility(p0: Array<out AMapNaviTrafficFacilityInfo>?) {

    }

    override fun OnUpdateTrafficFacility(p0: AMapNaviTrafficFacilityInfo?) {

    }

    override fun updateAimlessModeStatistics(p0: AimLessModeStat?) {

    }

    override fun updateAimlessModeCongestionInfo(p0: AimLessModeCongestionInfo?) {

    }

    override fun onPlayRing(p0: Int) {

    }

    override fun onNaviRouteNotify(p0: AMapNaviRouteNotifyData?) {

    }

    override fun onGpsSignalWeak(p0: Boolean) {

    }

    override fun onNaviSetting() {

    }

    override fun onNaviCancel() {

    }

    override fun onNaviBackClick(): Boolean {
        return false
    }

    override fun onNaviMapMode(p0: Int) {

    }

    override fun onNaviTurnClick() {

    }

    override fun onNextRoadClick() {

    }

    override fun onScanViewButtonClick() {

    }

    override fun onLockMap(p0: Boolean) {

    }

    override fun onNaviViewLoaded() {

    }

    override fun onMapTypeChanged(p0: Int) {

    }

    override fun onNaviViewShowMode(p0: Int) {

    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events;
    }

    override fun onCancel(arguments: Any?) {
        eventChannel?.setStreamHandler(null);
        eventChannel = null
        eventSink = null
    }


    private fun drawRoutes(routeId: Int, path: AMapNaviPath) {
//        map.moveCamera(CameraUpdateFactory.changeTilt(0f))
//        val routeOverLay = RouteOverLay(map, path, context)
//        routeOverLay.isTrafficLine = false
//        routeOverLay.addToMap()
//        routeOverlays.put(routeId, routeOverLay)
    }
}
