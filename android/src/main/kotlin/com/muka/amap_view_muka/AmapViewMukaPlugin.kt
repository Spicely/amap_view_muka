package com.muka.amap_view_muka

import android.app.Activity
import android.text.TextUtils
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import com.amap.api.maps.MapsInitializer
import com.amap.api.navi.AMapNavi
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItemV2
import com.amap.api.services.help.Inputtips
import com.amap.api.services.help.InputtipsQuery
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.PoiResultV2
import com.amap.api.services.poisearch.PoiSearchV2
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** AmapViewMukaPlugin */
class AmapViewMukaPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private lateinit var activity: Activity

    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding

    private var channel: MethodChannel? = null

    companion object {
        const val AMAP_MUKA_MARKER = "plugins.muka.com/amap_view_muka_marker"
        const val AMAP_MUKA_SERVER = "plugins.muka.com/amap_view_muka_server"
        const val AMAP_MUKA_NAVI = "plugins.muka.com/amap_navi_view_muka"
        const val AMAP_MUKA_NAVI_CONTROLLER = "plugins.muka.com/amap_navi_view_muka_controller"
        const val AMAP_MUKA_NAVI_EVENT = "plugins.muka.com/amap_navi_view_muka_event"
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
    }


    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity

        flutterPluginBinding.platformViewRegistry.registerViewFactory(AMAP_MUKA_NAVI, AMapNaviViewFactory(activity, flutterPluginBinding))
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, AMAP_MUKA_SERVER)
        channel!!.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setApiKey" -> {
                val apiKeyMap = call.arguments as Map<*, *>
                if (apiKeyMap.containsKey("android") && !TextUtils.isEmpty(apiKeyMap["android"] as String?)) {
                    AMapNavi.setApiKey(activity.applicationContext, apiKeyMap["android"] as String?)
                }
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

            "searchKeyword" -> {
                try {
                    searchKeyword(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            "searchAround" -> {
                try {
                    searchAround(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
            }

            "fetchInputTips" -> {
                try {
                    fetchInputTips(call.arguments as Map<*, *>, result)
                } catch (e: Throwable) {
                    e.printStackTrace()
                }
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


    private fun searchKeyword(searchParams: Map<*, *>, result: Result) {
        val keyword = searchParams["keyword"] as String
        val city = searchParams["city"] as String
        val pageSize = searchParams["pageSize"] as Int
        val page = searchParams["page"] as Int
        val types = searchParams["types"] as String
        val cityLimit = searchParams["cityLimit"] as Boolean
        val query = PoiSearchV2.Query(keyword, types, city)
        query.pageSize = pageSize
        query.pageNum = page
        query.cityLimit = cityLimit
        val poiSearch = PoiSearchV2(activity.applicationContext, query)
        poiSearch.setOnPoiSearchListener(object : PoiSearchV2.OnPoiSearchListener {
            override fun onPoiSearched(res: PoiResultV2, rCode: Int) {
                if (rCode != 1000) {
                    result.success(mutableListOf<Any>())
                } else {
                    result.success(Convert.toArr(res))
                }
            }

            override fun onPoiItemSearched(p0: PoiItemV2?, p1: Int) {

            }

        })
        poiSearch.searchPOIAsyn()
    }

    private fun searchAround(searchParams: Map<*, *>, result: Result) {
        val keyword = searchParams["keyword"] as String
        val city = searchParams["city"] as String
        val latitude = searchParams["latitude"] as Double?
        val longitude = searchParams["longitude"] as Double?
        val types = searchParams["types"] as String
        val radius = searchParams["radius"] as Int
        val pageSize = searchParams["pageSize"] as Int
        val page = searchParams["page"] as Int

        val query = PoiSearchV2.Query(keyword, types, city)
        query.pageSize = pageSize
        query.pageNum = page
        val poiSearch = PoiSearchV2(activity.applicationContext, query)
        poiSearch.bound = PoiSearchV2.SearchBound(LatLonPoint(latitude!!, longitude!!), radius)
        poiSearch.setOnPoiSearchListener(object : PoiSearchV2.OnPoiSearchListener {
            override fun onPoiSearched(res: PoiResultV2, rCode: Int) {
                if (rCode != 1000) {
                    result.success(mutableListOf<Any>())
                } else {
                    result.success(Convert.toArr(res))
                }
            }

            override fun onPoiItemSearched(p0: PoiItemV2, p1: Int) {
            }

        })
        poiSearch.searchPOIAsyn()
    }

    private fun fetchInputTips(inputParams: Map<*, *>, result: Result) {
        val keyword = inputParams["keyword"] as String?
        val city = inputParams["city"] as String?
        val latitude = inputParams["latitude"] as Double?
        val longitude = inputParams["longitude"] as Double?
        val cityLimit = inputParams["cityLimit"] as Boolean

        val query = InputtipsQuery(keyword, city)
        if (latitude != null && longitude != null) {
            query.location = LatLonPoint(latitude, longitude)
        }
        query.cityLimit = cityLimit

        val inputTips = Inputtips(activity.applicationContext, query)
        inputTips.setInputtipsListener(object : Inputtips.InputtipsListener {
            override fun onGetInputtips(res: MutableList<Tip>?, rCode: Int) {
                if (rCode != 1000) {
                    result.success(emptyArray<Any>())
                } else {
                    if(res == null) {
                        result.success(emptyArray<Any>())
                    } else {
                       result.success(Convert.toArr(res))
                    }
                }
            }

        })
        inputTips.requestInputtipsAsyn()
    }

}
