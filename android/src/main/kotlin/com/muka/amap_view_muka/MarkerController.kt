package com.muka.amap_view_muka

import android.util.Log
import com.amap.api.maps.AMap
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.MarkerOptions
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.FlutterMain

class MarkerController(private val methodChannel: MethodChannel, private val map: AMap) {
    // markerId(dart端)与marker的映射关系
    private val markerIdToMarker = HashMap<String, Marker>();

    // markerId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
//    private val markerIdToOptions = HashMap<String, UnifiedMarkerOptions>();

    // Marker.Id与dart端markerId的映射关系
    private val markerIdToDartMarkerId = HashMap<String, String>();

    companion object {

    }

    fun deleteMarker(opts: Map<String, Any>, result: MethodChannel.Result){
        var id: String = (opts["id"] as String?)!!
        var markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            markerIdToDartMarkerId.remove(markerId)
            markerIdToMarker.remove(id)
        }
        result.success(true)
    }

    fun addMarker(opts: Map<String, Any>, result: MethodChannel.Result) {
        var type: String = (opts["type"] as String?)!!
        var id: String = (opts["id"] as String?)!!
        var position: Map<String, Any> = (opts["position"] as Map<String, Any>?)!!
        val latLng = LatLng(position["latitude"] as Double, position["longitude"] as Double)
        var title: String? = opts["title"] as String?
        var snippet: String? = opts["snippet"] as String?
//                        var anchor: String? = call.argument("anchor")
        var visible: Boolean = (opts["visible"] as Boolean?)!!
        var draggable: Boolean = (opts["draggable"] as Boolean?)!!
        var alpha: Float = (opts["alpha"] as Double?)!!.toFloat()
        var options = MarkerOptions()
        options.position(latLng).visible(visible).draggable(draggable).alpha(alpha).zIndex(1.0f)
        var icon: Map<String, Any>? = (opts["icon"] as Map<String, Any>?)

        if (title != null) {
            options.title(title)
        }
        if (snippet != null) {
            options.snippet(snippet)
        }
        var marker = map.addMarker(options)
        if(icon != null) {
            when(icon["type"]) {
                "marker#asset" -> {
                    var asset = BitmapDescriptorFactory.fromAsset(FlutterMain.getLookupKeyForAsset(icon["url"] as String))
                    marker.setIcon(asset)
                }
                "marker#web" -> {

                }
            }
        }
        when (type) {
            "defaultMarker" -> {
                markerIdToMarker[id] = marker
                markerIdToDartMarkerId[marker.id] = id
                result.success(true)
            }
        }
    }

    fun onClick(marker: Marker): Boolean {
        var id = marker.id
        var markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            var params = hashMapOf<String, String>()
            params["markerId"] = markerId
            methodChannel.invokeMethod("marker#onTap", params)
            return true
        }
        return false
    }

    fun onDrag(marker: Marker, type: String) {
        var id = marker.id
        var markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            var params = hashMapOf<String, Any>()
            params["markerId"] = markerId
            params["latLng"] = Convert.toJson(marker.position)
            methodChannel.invokeMethod(type, params)
        }
    }
}