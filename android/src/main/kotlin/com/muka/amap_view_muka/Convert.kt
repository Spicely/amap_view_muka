package com.muka.amap_view_muka

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
    }
}