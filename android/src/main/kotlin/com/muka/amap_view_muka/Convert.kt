package com.muka.amap_view_muka

import android.content.Context
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.view.ViewGroup
import android.widget.ImageView
import com.amap.api.maps.AMap
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.MyLocationStyle
import io.flutter.FlutterInjector

class Convert {
    companion object {
        fun toJson(latLng: LatLng): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = latLng.latitude
            data["longitude"] = latLng.longitude
            return data
        }

        fun getFlutterAsset(url: String, packageName: String?): String {
            if (packageName != null) {
                return FlutterInjector.instance().flutterLoader()
                    .getLookupKeyForAsset(url, packageName)
            }
            return FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(url)
        }

        fun toJson(position: CameraPosition): Any {
            val data = java.util.HashMap<String, Any>()
            data["latLng"] = toJson(position.target)
            data["zoom"] = position.zoom
            data["tilt"] = position.tilt
            data["bearing"] = position.bearing
            return data
        }

        fun initParams(params: Map<String, Any>, map: AMap, context: Context) {
            /// 地图显示位置
            if (params["cameraPosition"] != null) {
                val cameraPosition = (params["cameraPosition"] as Map<String, Any>?)!!
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
            }
            /// 指定屏幕中心点的手势操作
            if (params["pointToCenter"] != null) {
                val opts = params["pointToCenter"] as Map<String, Any>
                val x = (opts["x"] as Int?)!!
                val y = (opts["y"] as Int?)!!
                map.setPointToCenter(x, y)
                map.uiSettings.isGestureScaleByMapCenter = true
            }
            /// 地图类型
            if (params["type"] != null) {
                when (params["type"] as Int) {
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
            }
            /// 地图语言
            if (params["language"] != null) {
                when (params["language"] as Int) {
                    1 -> {
                        map.setMapLanguage(AMap.ENGLISH)
                    }
                    else -> {
                        map.setMapLanguage(AMap.CHINESE)
                    }
                }
            }
            /// 地图缩放等级
            if (params["zoomLevel"] != null) {
                map.moveCamera(CameraUpdateFactory.zoomTo((params["zoomLevel"] as Double).toFloat()))
            }
            /// 室内地图
            if (params["indoorMap"] != null) {
                map.showIndoorMap(params["indoorMap"] as Boolean)
            }
            /// 缩放按钮
            if (params["zoomControlsEnabled"] != null) {
                map.uiSettings.isZoomControlsEnabled = params["zoomControlsEnabled"] as Boolean
            }
            /// 指南针
            if (params["compassEnabled"] != null) {
                map.uiSettings.isCompassEnabled = params["compassEnabled"] as Boolean
            }
            /// 定位按钮
            if (params["myLocationButtonEnabled"] != null) {
                map.uiSettings.isMyLocationButtonEnabled =
                    params["myLocationButtonEnabled"] as Boolean
            }
            /// 定位按钮
            if (params["logoPosition"] != null) {
                when ((params["logoPosition"] as Int?)!!) {
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
            }
            /// 缩放手势
            if (params["zoomGesturesEnabled"] != null) {
                map.uiSettings.isZoomGesturesEnabled = params["zoomGesturesEnabled"] as Boolean
            }
            /// 滑动手势
            if (params["scrollGesturesEnabled"] != null) {
                map.uiSettings.isScrollGesturesEnabled = params["scrollGesturesEnabled"] as Boolean
            }
            /// 旋转手势
            if (params["rotateGesturesEnabled"] != null) {
                map.uiSettings.isRotateGesturesEnabled = params["rotateGesturesEnabled"] as Boolean
            }
            /// 倾斜手势
            if (params["tiltGesturesEnabled"] != null) {
                map.uiSettings.isTiltGesturesEnabled = params["tiltGesturesEnabled"] as Boolean
            }
            /// 所有手势
            if (params["allGesturesEnabled"] != null) {
                map.uiSettings.setAllGesturesEnabled(params["allGesturesEnabled"] as Boolean)
            }
            /// 蓝点设置
            if (params["myLocationStyle"] != null) {
                val opts = params["myLocationStyle"] as Map<String, Any>
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
                                        getFlutterAsset(
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
            }
        }
    }
}