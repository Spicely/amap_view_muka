package com.muka.amap_view_muka

import com.amap.api.maps.model.LatLng

class Convert {
    companion object {
        fun toJson(latLng: LatLng): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = latLng.latitude
            data["longitude"] = latLng.longitude
            return data
        }
    }
}