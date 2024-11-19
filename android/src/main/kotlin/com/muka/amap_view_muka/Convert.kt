package com.muka.amap_view_muka

import android.content.Context
import android.util.Log
import com.amap.api.location.AMapLocation
import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.MyLocationStyle
import com.amap.api.navi.AMapNaviView
import com.amap.api.navi.AMapNaviViewOptions
import com.amap.api.navi.enums.MapStyle
import com.amap.api.navi.model.AMapNaviCameraInfo
import com.amap.api.navi.model.AMapNaviForbiddenInfo
import com.amap.api.navi.model.AMapNaviLimitInfo
import com.amap.api.navi.model.AMapNaviLink
import com.amap.api.navi.model.AMapNaviPath
import com.amap.api.navi.model.AMapNaviRouteGuideGroup
import com.amap.api.navi.model.AMapNaviRouteGuideSegment
import com.amap.api.navi.model.AMapNaviStep
import com.amap.api.navi.model.AMapRestrictionInfo
import com.amap.api.navi.model.AMapTrafficIncidentInfo
import com.amap.api.navi.model.NaviLatLng
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItemV2
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.Business
import com.amap.api.services.poisearch.IndoorDataV2
import com.amap.api.services.poisearch.Photo
import com.amap.api.services.poisearch.PoiNavi
import com.amap.api.services.poisearch.PoiResultV2
import com.amap.api.services.poisearch.PoiSearchV2
import com.amap.api.services.poisearch.SubPoiItemV2
import com.autonavi.ae.route.RestrictionInfoDetail
import io.flutter.FlutterInjector


class Convert {
    companion object {
        fun toNaviParams(params: Map<String, Any>) {

        }

        fun toJson(params: LatLng): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = params.latitude
            data["longitude"] = params.longitude
            return data
        }

        fun toJson(params: NaviLatLng): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = params.latitude
            data["longitude"] = params.longitude
            return data
        }

        fun toJson(params: AMapNaviLink): Any {
            val data = HashMap<String, Any>()
            data["coords"] = params.coords.map { v -> toJson(v) }
            data["roadName"] = params.roadName
            data["length"] = params.length
            data["time"] = params.time
            data["roadClass"] = params.roadClass
            data["roadType"] = params.roadType
            data["ownershipType"] = params.ownershipType
            data["trafficLights"] = params.trafficLights
            data["trafficFineStatus"] = params.trafficFineStatus
            return data
        }

        fun toJson(params: AMapNaviCameraInfo): Any {
            val data = HashMap<String, Any>()
            data["cameraDistance"] = params.cameraDistance
            data["cameraSpeed"] = params.cameraSpeed
            data["cameraType"] = params.cameraType
            data["averageSpeed"] = params.averageSpeed
            data["reasonableSpeedInRemainDist"] = params.reasonableSpeedInRemainDist
            data["intervalRemainDistance"] = params.intervalRemainDistance
            return data
        }

        fun toJson(params: AMapRestrictionInfo): Any {
            val data = HashMap<String, Any>()
            data["cityCode"] = params.cityCode
            data["restrictionTitle"] = params.restrictionTitle
            data["tips"] = params.tips
            data["titleType"] = params.titleType
            data["infoDetailList"] = params.infoDetailList.map { i -> toJson(i) }
            return data
        }

        fun toJson(params: RestrictionInfoDetail): Any {
            val data = HashMap<String, Any>()
            data["ruleid"] = params.ruleid
            data["restrictionTitle"] = params.low
            data["high"] = params.high
            data["hitTime"] = params.hitTime
            data["headX"] = params.headX
            data["headY"] = params.headY
            data["tailX"] = params.tailX
            data["tailY"] = params.tailY
            data["valid"] = params.valid
            return data
        }

        fun toJson(params: AMapNaviRouteGuideGroup): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["groupEnterCoord"] = toJson(params.groupEnterCoord)
            data["groupName"] = params.groupName
            data["groupLen"] = params.groupLen
            data["groupTime"] = params.groupTime
            data["trafficLightsCount"] = params.trafficLightsCount
            data["groupIconType"] = params.groupIconType
            data["segments"] = params.segments.map { i -> toJson(i) }
            return data
        }

        fun toJson(params: AMapNaviRouteGuideSegment): Any {
            val data = HashMap<String, Any>()
            data["stepIconType"] = params.stepIconType
            data["description"] = params.description
            data["isArriveWayPoint"] = params.isArriveWayPoint
            return data
        }


        fun toJson(location: AMapLocation): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = location.latitude
            data["longitude"] = location.longitude
            data["accuracy"] = location.accuracy
            data["speed"] = location.speed
            data["time"] = location.time
            // 以下是定位sdk返回的逆地理信息
            data["coordType"] = location.coordType
            data["country"] = location.country
            data["city"] = location.city
            data["district"] = location.district
            data["street"] = location.street
            data["address"] = location.address
            data["province"] = location.province
            return data
        }

        fun toJson(params: AMapNaviStep): Any {
            val data = HashMap<String, Any>()
            data["length"] = params.length
            data["time"] = params.time
            data["tollCost"] = params.tollCost
            data["trafficLightCount"] = params.trafficLightCount
            data["isArriveWayPoint"] = params.isArriveWayPoint
            data["chargeLength"] = params.chargeLength
            data["startIndex"] = params.startIndex
            data["endIndex"] = params.endIndex
            data["coords"] = params.coords.map { v -> toJson(v) }
            data["links "] = params.links.map { v -> toJson(v) }
            data["iconType"] = params.iconType
            return data
        }

        fun toJson(params: AMapTrafficIncidentInfo): Any {
            val data = HashMap<String, Any>()
            data["longitude"] = params.longitude
            data["latitude"] = params.latitude
            data["title"] = params.title
            data["type"] = params.type
            return data
        }

        fun toJson(params: AMapNaviLimitInfo): Any {
            val data = HashMap<String, Any>()
            data["pathId"] = params.pathId
            data["type"] = params.type
            data["longitude"] = params.longitude
            data["latitude"] = params.latitude
            data["currentRoadName"] = params.currentRoadName
            return data
        }

        fun toJson(params: AMapNaviForbiddenInfo): Any {
            val data = HashMap<String, Any>()
            data["pathId"] = params.pathId
            data["forbiddenType"] = params.forbiddenType
            data["forbiddenTime"] = params.forbiddenTime
            data["carType"] = params.carType
            data["longitude"] = params.longitude
            data["latitude"] = params.latitude
            data["roadName"] = params.roadName
            data["nextRoadName"] = params.nextRoadName
            data["segIndex"] = params.segIndex
            data["linkIndex"] = params.linkIndex
            data["carTypeDesc"] = params.carTypeDesc
            return data
        }

        fun toJson(params: HashMap<Int, AMapNaviPath>): Any {
            val data = HashMap<Int, Any>()
            params.forEach { (key, value) ->
                val v = HashMap<String, Any>()
                v["allLength"] = value.allLength
                v["allTime"] = value.allTime
                v["stepsCount"] = value.stepsCount
                v["tollCost"] = value.tollCost
                v["routeType"] = value.routeType
                v["pathid"] = value.pathid
                v["mainRoadInfo"] = value.mainRoadInfo
//                v["labelId"] = value.labelId
//                v["wayPointIndex"] = value.wayPointIndex
                v["cityAdcodeList"] = value.cityAdcodeList
                v["allTime"] = value.allTime
                val trafficStatuses = arrayListOf<Map<String, Any>>()
                value.trafficStatuses.forEach { i ->
                    val tra = HashMap<String, Any>()
                    tra["linkIndex"] = i.linkIndex
                    tra["status"] = i.status
                    tra["linkIndex"] = i.trafficFineStatus
                    tra["length"] = i.length
                    trafficStatuses.add(tra)
                }
                v["trafficStatuses"] = trafficStatuses
                v["steps"] = value.steps.map { i -> toJson(i) }
                v["startPoint"] = toJson(value.startPoint)
                v["endPoint"] = toJson(value.endPoint)
//                v["carToFootPoint"] = toJson(value.carToFootPoint)
                v["lightList"] = value.lightList.map { i -> toJson(i) }
                v["wayPoint"] = value.wayPoint.map { i -> toJson(i) }
                v["allCameras"] = value.allCameras.map { i -> toJson(i) }
                v["trafficStatuses"] = toJson(value.restrictionInfo)
                v["naviGuideList"] = value.naviGuideList.map { i -> toJson(i) }
                v["trafficIncidentInfo"] = value.trafficIncidentInfo.map { i -> toJson(i) }
                v["limitInfos"] = value.limitInfos.map { i -> toJson(i) }
                v["forbiddenInfos"] = value.forbiddenInfos.map { i -> toJson(i) }

                data[key] = v
            }

            return data
        }

        fun toJson(params: LatLonPoint): HashMap<String, Any> {
            val v = HashMap<String, Any>()
            v["latitude"] = params.latitude
            v["longitude"] = params.longitude
            return v;
        }

        fun toJson(params: PoiSearchV2.SearchBound): HashMap<String, Any> {
            val v = HashMap<String, Any>()
            if (params.center != null) {
                v["center"] = toJson(params.center)
            }
            if (params.lowerLeft != null) {
                v["lowerLeft"] = toJson(params.lowerLeft)
            }
            if (params.upperRight != null) {
                v["upperRight"] = toJson(params.upperRight)
            }
            v["range"] = params.range
            v["shape"] = params.shape
            v["isDistanceSort"] = params.isDistanceSort
            v["polyGonList"] = toArrLatLon(params.polyGonList)
            return v;
        }

        fun toJson(params: Business): HashMap<String, Any> {
            val v = HashMap<String, Any>()
            v["businessArea"] = params.businessArea
            v["tag"] = params.tag
            v["tel"] = params.tel
            v["cost"] = params.cost
            v["alias"] = params.alias
            v["cpid"] = params.cpid
            v["parkingType"] = params.parkingType
            v["opentimeToday"] = params.opentimeToday
            v["opentimeWeek"] = params.opentimeWeek
            return v;
        }

        fun toJson(params: PoiNavi): HashMap<String, Any> {
            val v = HashMap<String, Any>()
            if (params.exit != null) {
                v["exit"] = toJson(params.exit)
            }
            if (params.enter != null) {
                v["enter"] = toJson(params.enter)
            }
            v["gridCode"] = params.gridCode
            v["naviPoiID"] = params.naviPoiID
            return v;
        }

        fun toJson(params: PoiItemV2): HashMap<String, Any> {
            val v = HashMap<String, Any>()
            v["poiId"] = params.poiId
            v["title"] = params.title
            v["typeDes"] = params.typeDes
            v["typeCode"] = params.typeCode
            v["snippet"] = params.snippet
            v["provinceName"] = params.provinceName
            v["provinceCode"] = params.provinceCode
            v["cityName"] = params.cityName
            v["cityCode"] = params.cityCode
            v["adCode"] = params.adCode
            v["indoorData"] = toJson(params.indoorData)
            v["latLonPoint"] = toJson(params.latLonPoint)
            v["adName"] = params.adName
            v["business"] = toJson(params.business)
            v["poiNavi"] = toJson(params.poiNavi)
            v["photos"] = toArrPhoto(params.photos)
            v["subPois"] = toArrSubPoiItem(params.subPois)
            return v;
        }

        fun toJson(result: SubPoiItemV2): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["poiId"] = result.poiId
            data["title"] = result.title
            data["typeCode"] = result.typeCode
            data["snippet"] = result.snippet
            data["latLonPoint"] = toJson(result.latLonPoint)
            data["subTypeDes"] = result.subTypeDes
            return data
        }

        fun toJson(result: PoiResultV2): Map<String, Any> {
            val data = HashMap<String, Any>()
            if (result.bound != null) {
                data["bound"] = toJson(result.bound)
            }
            data["pois"] = toArrPoiItem(result.pois)
            data["count"] = result.count
            return data
        }

        fun toJson(result: Photo): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["url"] = result.url
            data["title"] = result.title
            return data
        }

        fun toJson(position: CameraPosition): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["latLng"] = toJson(position.target)
            data["zoom"] = position.zoom
            data["tilt"] = position.tilt
            data["bearing"] = position.bearing
            return data
        }

        private fun toArrSubPoiItem(result: MutableList<SubPoiItemV2>): MutableList<HashMap<String, Any>> {
            val arr: MutableList<HashMap<String, Any>> = ArrayList()
            result.forEachIndexed { _, it ->
                arr.add(toJson(it))
            }
            return arr;
        }

        private fun toArrPhoto(result: MutableList<Photo>): MutableList<HashMap<String, Any>> {
            val arr: MutableList<HashMap<String, Any>> = ArrayList()
            result.forEach { it ->
                arr.add(toJson(it))
            }
            return arr;
        }

        private fun toArrLatLon(result: MutableList<LatLonPoint>): MutableList<HashMap<String, Any>> {
            val arr: MutableList<HashMap<String, Any>> = ArrayList()
            result.forEach { it ->
                arr.add(toJson(it))
            }
            return arr;
        }

        private fun toArrPoiItem(result: MutableList<PoiItemV2>): MutableList<HashMap<String, Any>> {
            val arr: MutableList<HashMap<String, Any>> = ArrayList()
            result.forEachIndexed { _, it ->
                arr.add(toJson(it))
            }
            return arr;
        }

        fun toArrTip(result: MutableList<Tip>): MutableList<HashMap<String, Any>> {
            val arr: MutableList<HashMap<String, Any>> = ArrayList()
            result.forEachIndexed { _, it ->
                run {
                    val data = HashMap<String, Any>()
                    data["id"] = it.poiID
                    data["name"] = it.name
                    data["adCode"] = it.adcode
                    data["address"] = it.address
                    data["typeCode"] = it.typeCode
                    if (it.point != null) {
                        data["point"] = toJson(it.point)
                    }
                    data["district"] = it.district
                    arr.add(data)
                }
            }
            return arr
        }

        fun getFlutterAsset(url: String, packageName: String?): String {
            if (packageName != null) {
                return FlutterInjector.instance().flutterLoader()
                    .getLookupKeyForAsset(url, packageName)
            }
            return FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(url)
        }

        fun toArrayNaviLatLng(params: List<Map<String, Any>>): MutableList<NaviLatLng> {
            val data: MutableList<NaviLatLng> = ArrayList()
            for (i in params) {
                data.add(toNaviLatLng(i))
            }
            return data
        }

        fun toNaviLatLng(params: Map<*, *>): NaviLatLng {
            return NaviLatLng(params["latitude"] as Double, params["longitude"] as Double)
        }

        fun toLatLng(params: Map<*, *>): LatLng {
            return LatLng(params["latitude"] as Double, params["longitude"] as Double)
        }


        fun setAMap(params: Map<*, *>, aMap: AMap) {
            val myLocationStyle = params["myLocationStyle"] as Map<*, *>
            val uiSettings = params["uiSettings"] as Map<*, *>
            aMap.isMyLocationEnabled = params["isMyLocationEnabled"] as Boolean
            aMap.myLocationStyle =
                MyLocationStyle().myLocationType(myLocationStyle["myLocationType"] as Int)
            aMap.uiSettings.zoomPosition = uiSettings["zoomPosition"] as Int
            aMap.moveCamera(CameraUpdateFactory.zoomTo((params["zoom"] as Double).toFloat()))
        }

        fun initParams(params: Map<*, *>, mAMapNaviView: AMapNaviView, context: Context) {
            Log.e("initParams", "initParams: ${params}", )
            setAMap(params["aMap"] as Map<*, *>, mAMapNaviView.map)
//            /// 地图显示位置
//            if (params["cameraPosition"] != null) {
//                val cameraPosition = (params["cameraPosition"] as Map<*, *>?)!!
//                val latLng = (cameraPosition["latLng"] as Map<*, *>?)!!
//                val zoom = (cameraPosition["zoom"] as Double?)!!
//                val tilt = (cameraPosition["tilt"] as Double?)!!
//                val bearing = (cameraPosition["bearing"] as Double?)!!
//                val duration = cameraPosition["duration"] as Int?
//                val mCameraUpdate = CameraUpdateFactory.newCameraPosition(
//                    CameraPosition(
//                        LatLng(
//                            latLng["latitude"] as Double,
//                            latLng["longitude"] as Double
//                        ), zoom.toFloat(), tilt.toFloat(), bearing.toFloat()
//                    )
//                )
//                if (duration == null) {
//                    map.moveCamera(mCameraUpdate)
//                } else {
//                    map.animateCamera(mCameraUpdate, duration.toLong(), null)
//                }
//            }
//            /// 指定屏幕中心点的手势操作
//            if (params["pointToCenter"] != null) {
//                val opts = params["pointToCenter"] as Map<String, Any>
//                val x = (opts["x"] as Int?)!!
//                val y = (opts["y"] as Int?)!!
//                map.setPointToCenter(x, y)
//                map.uiSettings.isGestureScaleByMapCenter = true
//            }
//            /// 地图类型
//            if (params["type"] != null) {
//                when (params["type"] as Int) {
//                    0 -> {
//                        map.mapType = AMap.MAP_TYPE_NAVI
//                    }
//
//                    1 -> {
//                        map.mapType = AMap.MAP_TYPE_NIGHT
//                    }
//
//                    3 -> {
//                        map.mapType = AMap.MAP_TYPE_SATELLITE
//                    }
//
//                    4 -> {
//                        map.mapType = AMap.MAP_TYPE_BUS
//                    }
//
//                    else -> {
//                        map.mapType = AMap.MAP_TYPE_NORMAL
//                    }
//                }
//            }
//            /// 地图语言
//            if (params["language"] != null) {
//                when (params["language"] as Int) {
//                    1 -> {
//                        map.setMapLanguage(AMap.ENGLISH)
//                    }
//
//                    else -> {
//                        map.setMapLanguage(AMap.CHINESE)
//                    }
//                }
//            }
//            /// 地图缩放等级
//            if (params["zoomLevel"] != null) {
//                map.moveCamera(CameraUpdateFactory.zoomTo((params["zoomLevel"] as Double).toFloat()))
//            }
//            /// 室内地图
//            if (params["indoorMap"] != null) {
//                map.showIndoorMap(params["indoorMap"] as Boolean)
//            }
//            /// 缩放按钮
//            if (params["zoomControlsEnabled"] != null) {
//                map.uiSettings.isZoomControlsEnabled = params["zoomControlsEnabled"] as Boolean
//            }
//            /// 指南针
//            if (params["compassEnabled"] != null) {
//                map.uiSettings.isCompassEnabled = params["compassEnabled"] as Boolean
//            }
//            /// 定位按钮
//            if (params["myLocationButtonEnabled"] != null) {
//                map.uiSettings.isMyLocationButtonEnabled =
//                    params["myLocationButtonEnabled"] as Boolean
//            }
//            /// 定位按钮
//            if (params["logoPosition"] != null) {
//                when ((params["logoPosition"] as Int?)!!) {
//                    1 -> {
//                        map.uiSettings.logoPosition = AMapOptions.LOGO_MARGIN_BOTTOM
//                    }
//
//                    2 -> {
//                        map.uiSettings.logoPosition = AMapOptions.LOGO_MARGIN_RIGHT
//                    }
//
//                    3 -> {
//                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_CENTER
//                    }
//
//                    4 -> {
//                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_RIGHT
//                    }
//
//                    else -> {
//                        map.uiSettings.logoPosition = AMapOptions.LOGO_POSITION_BOTTOM_LEFT
//                    }
//                }
//            }
//            /// 缩放手势
//            if (params["zoomGesturesEnabled"] != null) {
//                map.uiSettings.isZoomGesturesEnabled = params["zoomGesturesEnabled"] as Boolean
//            }
//            /// 滑动手势
//            if (params["scrollGesturesEnabled"] != null) {
//                map.uiSettings.isScrollGesturesEnabled = params["scrollGesturesEnabled"] as Boolean
//            }
//            /// 旋转手势
//            if (params["rotateGesturesEnabled"] != null) {
//                map.uiSettings.isRotateGesturesEnabled = params["rotateGesturesEnabled"] as Boolean
//            }
//            /// 倾斜手势
//            if (params["tiltGesturesEnabled"] != null) {
//                map.uiSettings.isTiltGesturesEnabled = params["tiltGesturesEnabled"] as Boolean
//            }
//            /// 所有手势
//            if (params["allGesturesEnabled"] != null) {
//                map.uiSettings.setAllGesturesEnabled(params["allGesturesEnabled"] as Boolean)
//            }
//
//            /// 蓝点设置
//            if (params["myLocationStyle"] != null) {
//                val opts = params["myLocationStyle"] as Map<String, Any>
//                val locationStyle = (opts["locationStyle"] as Int?)!!
//                val interval = (opts["interval"] as Int?)!!
//                val enabled = (opts["enabled"] as Boolean?)!!
//                val myLocationStyle = MyLocationStyle()
//                val icon: Map<String, Any>? = (opts["icon"] as Map<String, Any>?)
//                val anchor: Map<String, Any>? = (opts["anchor"] as Map<String, Any>?)
//                val strokeColor = opts["strokeColor"] as List<Int>?
//                val radiusFillColor = opts["radiusFillColor"] as List<Int>?
//                val strokeWidth = opts["strokeWidth"] as Double?
//
//                if (anchor != null) {
//                    myLocationStyle.anchor(
//                        (anchor["u"] as Double).toFloat(),
//                        (anchor["v"] as Double).toFloat()
//                    )
//                }
//
//                if (strokeColor != null) {
//                    myLocationStyle.strokeColor(
//                        Color.rgb(
//                            strokeColor[0],
//                            strokeColor[1],
//                            strokeColor[2]
//                        )
//                    )
//                }
//
//                if (radiusFillColor != null) {
//                    myLocationStyle.radiusFillColor(
//                        Color.rgb(
//                            radiusFillColor[0],
//                            radiusFillColor[1],
//                            radiusFillColor[2]
//                        )
//                    )
//                }
//
//                if (strokeWidth != null) {
//                    myLocationStyle.strokeWidth(strokeWidth.toFloat())
//                }
//
//                when (locationStyle) {
//                    1 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATE)
//                    }
//
//                    2 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW)
//                    }
//
//                    3 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_MAP_ROTATE)
//                    }
//
//                    4 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE)
//                    }
//
//                    5 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER)
//                    }
//
//                    6 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_FOLLOW_NO_CENTER)
//                    }
//
//                    7 -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_MAP_ROTATE_NO_CENTER)
//                    }
//
//                    else -> {
//                        myLocationStyle.myLocationType(MyLocationStyle.LOCATION_TYPE_SHOW)
//                    }
//                }
//
//
//
//                myLocationStyle.interval(interval.toLong())
//                myLocationStyle.showMyLocation(enabled)
//                if (icon != null) {
//                    when (icon["type"]) {
//                        "marker#asset" -> {
//                            val size = icon["size"] as Map<String, Any>
//                            val imageView = ImageView(context)
//                            val params =
//                                ViewGroup.LayoutParams(
//                                    (size["width"] as Double).toInt(),
//                                    (size["height"] as Double).toInt()
//                                )
//                            val assetManager: AssetManager = context.assets
//                            imageView.setImageBitmap(
//                                BitmapFactory.decodeStream(
//                                    assetManager.open(
//                                        getFlutterAsset(
//                                            icon["url"] as String,
//                                            icon["package"] as String?
//                                        )
//                                    )
//                                )
//                            )
//                            imageView.layoutParams = params
//                            val asset = BitmapDescriptorFactory.fromView(imageView)
//                            myLocationStyle.myLocationIcon(asset)
//                        }
//
//                        "marker#web" -> {
//
//                        }
//                    }
//                }
//                map.myLocationStyle = myLocationStyle
//                map.isMyLocationEnabled = true
//            }
        }

        fun toJson(data: IndoorDataV2): HashMap<String, Any> {
            val map = HashMap<String, Any>()
            map["floor"] = data.floor
            map["floorName"] = data.floorName
            map["id"] = data.poiId
            map["isIndoorMap"] = data.isIndoorMap
            return map
        }


        fun toAMapNaviViewOptions(arguments: Map<*, *>): AMapNaviViewOptions {
            val options = AMapNaviViewOptions()
            options.isAutoDrawRoute = arguments["isAutoDrawRoute"] as Boolean
            options.setModeCrossDisplayShow(arguments["isModelCrossDisplayShow"] as Boolean)
            options.isRealCrossDisplayShow = arguments["isRealCrossDisplayShow"] as Boolean
            options.isLaneInfoShow = arguments["isLaneInfoShow"] as Boolean
            options.isCompassEnabled = arguments["isCompassEnabled"] as Boolean
            options.isTrafficBarEnabled = arguments["isTrafficBarEnabled"] as Boolean
            options.isTrafficLayerEnabled = arguments["isTrafficLayerEnabled"] as Boolean
            options.isRouteListButtonShow = arguments["isRouteListButtonShow"] as Boolean
            options.isNaviArrowVisible = arguments["isNaviArrowVisible"] as Boolean
            options.isSettingMenuEnabled = arguments["isSettingMenuEnabled"] as Boolean
            options.isTrafficLine = arguments["isTrafficLine"] as Boolean
            options.isLayoutVisible = arguments["isLayoutVisible"] as Boolean
            options.isAutoChangeZoom = arguments["isAutoChangeZoom"] as Boolean
            options.isSensorEnable = arguments["isSensorEnable"] as Boolean
            options.isAutoLockCar = arguments["isAutoLockCar"] as Boolean
            options.isAutoDisplayOverview = arguments["isAutoDisplayOverview"] as Boolean
            options.isAfterRouteAutoGray = arguments["isAfterRouteAutoGray"] as Boolean
            options.isDrawBackUpOverlay = arguments["isDrawBackUpOverlay"] as Boolean
            options.isSecondActionVisible = arguments["isSecondActionVisible"] as Boolean
            options.setMapStyle(
                MapStyle.getEnum(arguments["mapStyle"] as Int), arguments["mapStylePath"] as String
            )
            return options
        }
    }
}
