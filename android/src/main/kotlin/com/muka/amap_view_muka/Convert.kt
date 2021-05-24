package com.muka.amap_view_muka

import android.content.Context
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.graphics.Color
import android.view.ViewGroup
import android.widget.ImageView
import com.amap.api.maps.AMap
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
            data["bearing"] = position.bearing
            data["target"] = toJson(position.target)
            data["tilt"] = position.tilt
            data["zoom"] = position.zoom
            return data
        }

        fun initParams(params: Map<String, Any>, map: AMap, context: Context) {
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
                                ViewGroup.LayoutParams(size["width"] as Int, size["height"] as Int)
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