package com.muka.amap_view_muka

import com.amap.api.maps.AMap
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.LatLng
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

        fun initParams(params: Map<String,Any>, map: AMap) {
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
        }
    }
}