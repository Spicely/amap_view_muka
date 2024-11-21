package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.util.SparseArray
import android.view.View
import androidx.core.app.ActivityCompat
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
import com.amap.api.navi.model.NaviLatLng
import com.amap.api.navi.view.RouteOverLay
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory


class AMapNaviViewFactory(
    private val activity: Activity, private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        // 申请权限
        ActivityCompat.requestPermissions(
            activity, arrayOf(
                Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.WRITE_EXTERNAL_STORAGE, Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.READ_PHONE_STATE
            ), 321
        )
        val params = args as Map<*, *>
        return AMapNaviView(context, viewId, flutterPluginBinding, params)
    }
}


class AMapNaviView(
    private val context: Context, private val id: Int, private val flutterPluginBinding: FlutterPlugin.FlutterPluginBinding, private val params: Map<*, *>
) : PlatformView, AMapNaviListener, AMapNaviViewListener, EventChannel.StreamHandler, MethodChannel.MethodCallHandler {


    private var mAMapNaviView: AMapNaviView = AMapNaviView(context, Convert.toAMapNaviViewOptions(params["viewOptions"] as Map<*, *>))

    private var mAMapNavi: AMapNavi

    // marker控制器
    private val methodChannel: MethodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "${AmapViewMukaPlugin.AMAP_MUKA_NAVI_CONTROLLER}_$id")

    private var eventSink: EventChannel.EventSink? = null

    private var eventChannel: EventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "${AmapViewMukaPlugin.AMAP_MUKA_NAVI_EVENT}_$id")

    private var resultSkip: MethodChannel.Result? = null

    private var cropOpts: Map<String, Any>? = null

    /**
     * 保存当前算好的路线
     */
    private val routeOverlays: SparseArray<RouteOverLay> = SparseArray<RouteOverLay>()

    init {
        mAMapNaviView.onCreate(null)
        mAMapNavi = AMapNavi.getInstance(context)

        mAMapNaviView.setAMapNaviViewListener(this)
        mAMapNavi.setUseInnerVoice(true, true)
        mAMapNavi.addAMapNaviListener(this)
        methodChannel.setMethodCallHandler(this)

//        val myLocationStyle = MyLocationStyle()
//        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE)
//        myLocationStyle.showMyLocation(true)


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

            "calculateDriveRoute" -> {
                calculateDriveRoute(args)
                result.success(null)
            }

            "strategyConvert" -> {
                result.success(strategyConvert(args))
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun strategyConvert(params: Map<*, *>): Int {
        val avoidCongestion = params["avoidCongestion"] as Boolean
        val avoidHighway = params["avoidHighway"] as Boolean
        val avoidCost = params["avoidCost"] as Boolean
        val prioritiseHighway = params["prioritiseHighway"] as Boolean
        val multipleRoute = params["multipleRoute"] as Boolean
        return mAMapNavi.strategyConvert(avoidCongestion, avoidHighway, avoidCost, prioritiseHighway, multipleRoute)
    }

    /// 计算驾车路径
    private fun calculateDriveRoute(params: Map<*, *>) {
        val startList = Convert.toArrayNaviLatLng(params["start"] as List<Map<String, Any>>)
        val wayList = Convert.toArrayNaviLatLng(params["way"] as List<Map<String, Any>>)
        val endList = Convert.toArrayNaviLatLng(params["end"] as List<Map<String, Any>>)
        val flag = params["strategy"] as Int
        mAMapNavi.calculateDriveRoute(startList, wayList, endList, flag)
    }


    override fun onInitNaviFailure() {
        methodChannel.invokeMethod("onInitNaviFailure", null)
    }

    override fun onInitNaviSuccess() {
        Convert.initParams(params, mAMapNaviView, context)
        methodChannel.invokeMethod("onInitNaviSuccess", null)
    }

    override fun onStartNavi(type: Int) {
        methodChannel.invokeMethod("onStartNavi", type)
    }

    override fun onTrafficStatusUpdate() {
        methodChannel.invokeMethod("onTrafficStatusUpdate", null)
    }

    override fun onLocationChange(location: AMapNaviLocation?) {

        methodChannel.invokeMethod("onLocationChange", if (location != null) Convert.toJson(location) else null)
    }

    override fun onGetNavigationText(type: Int, text: String?) {
        val hashMap = HashMap<String, Any?>()
        hashMap["type"] = type
        hashMap["text"] = text
        methodChannel.invokeMethod("onGetNavigationText", hashMap)
    }

    @Deprecated("Deprecated in Java")
    override fun onGetNavigationText(text: String?) {

    }

    override fun onEndEmulatorNavi() {
        methodChannel.invokeMethod("onEndEmulatorNavi", null)
    }

    override fun onArriveDestination() {
        methodChannel.invokeMethod("onArriveDestination", null)
    }


    @Deprecated("Deprecated in Java")
    override fun onCalculateRouteFailure(p0: Int) {
    }

    override fun onCalculateRouteFailure(p0: AMapCalcRouteResult?) {
        val data: MutableMap<String, Any?> = mutableMapOf()
        data["type"] = "calculateRouteFailure"
        data["data"] = 1
        methodChannel.invokeMethod("onCalculateRouteFailure", null)

    }

    override fun onReCalculateRouteForYaw() {
        methodChannel.invokeMethod("onReCalculateRouteForYaw", null)
    }

    override fun onReCalculateRouteForTrafficJam() {
        methodChannel.invokeMethod("onReCalculateRouteForTrafficJam", null)
    }

    override fun onArrivedWayPoint(wayID: Int) {
        methodChannel.invokeMethod("onArrivedWayPoint", wayID)
    }

    override fun onGpsOpenStatus(enabled: Boolean) {
        methodChannel.invokeMethod("onGpsOpenStatus", enabled)
    }

    override fun onNaviInfoUpdate(naviInfo: NaviInfo?) {
        methodChannel.invokeMethod("onNaviInfoUpdate", naviInfo?.toString())
    }

    override fun updateCameraInfo(p0: Array<out AMapNaviCameraInfo>?) {

    }

    override fun updateIntervalCameraInfo(p0: AMapNaviCameraInfo?, p1: AMapNaviCameraInfo?, p2: Int) {

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
    override fun onCalculateRouteSuccess(routeResult: AMapCalcRouteResult) {

        methodChannel.invokeMethod("onCalculateRouteSuccess", Convert.toJson(routeResult))
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
