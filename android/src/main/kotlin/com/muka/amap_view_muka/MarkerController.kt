package com.muka.amap_view_muka

import android.content.Context
import android.content.res.AssetManager
import android.graphics.BitmapFactory
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import com.amap.api.maps.AMap
import com.amap.api.maps.model.BitmapDescriptorFactory
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Marker
import com.amap.api.maps.model.MarkerOptions
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodChannel

class MarkerController(private val methodChannel: MethodChannel, private val map: AMap) {
    // markerId(dart端)与marker的映射关系
    private val markerIdToMarker = HashMap<String, Marker>();

    // markerId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
    private val markerIdToOptions = HashMap<String, Map<String, Any>>();

    // Marker.Id与dart端markerId的映射关系
    private val markerIdToDartMarkerId = HashMap<String, String>();

    companion object {

    }

    fun deleteMarker(opts: Map<String, Any>, result: MethodChannel.Result) {
        val id: String = (opts["id"] as String?)!!
        val markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            markerIdToDartMarkerId.remove(markerId)
            markerIdToMarker.remove(id)
        }
        result.success(true)
    }

    fun addMarker(opts: Map<String, Any>, context: Context, result: MethodChannel.Result) {
        val type: String = (opts["type"] as String?)!!
        val id: String = (opts["id"] as String?)!!
        val position: Map<String, Any> = (opts["position"] as Map<String, Any>?)!!
        val latLng = LatLng(position["latitude"] as Double, position["longitude"] as Double)
        val title: String? = opts["title"] as String?
        val snippet: String? = opts["snippet"] as String?
//                        var anchor: String? = call.argument("anchor")
        val visible: Boolean = (opts["visible"] as Boolean?)!!
        val draggable: Boolean = (opts["draggable"] as Boolean?)!!
        val alpha: Float = (opts["alpha"] as Double?)!!.toFloat()
        val options = MarkerOptions()
        options.position(latLng).visible(visible).draggable(draggable).alpha(alpha).zIndex(1.0f)
        val icon: Map<String, Any>? = (opts["icon"] as Map<String, Any>?)

        if (title != null) {
            options.title(title)
        }
        if (snippet != null) {
            options.snippet(snippet)
        }
        val marker = map.addMarker(options)
        markerIdToOptions[marker.id] = opts
        if (icon != null) {
            when (icon["type"]) {
                "marker#asset" -> {
                    val size = icon["size"] as Map<String, Any>
                    val imageView = ImageView(context)
                    val params = ViewGroup.LayoutParams(size["width"] as Int, size["height"] as Int)
                    val assetManager: AssetManager = context.assets
                    imageView.setImageBitmap(BitmapFactory.decodeStream(assetManager.open(
                        FlutterInjector.instance().flutterLoader()
                            .getLookupKeyForAsset(icon["url"] as String)
                    )
                    )
                    )
                    imageView.layoutParams = params
                    val asset = BitmapDescriptorFactory.fromView(imageView)
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

    fun updateMarker(opts: Map<String, Any>, context: Context, result: MethodChannel.Result) {
        val type: String = (opts["type"] as String?)!!
        val id: String = (opts["id"] as String?)!!
        val position: Map<String, Any> = (opts["position"] as Map<String, Any>?)!!
        val latLng = LatLng(position["latitude"] as Double, position["longitude"] as Double)
        val title: String? = opts["title"] as String?
        val snippet: String? = opts["snippet"] as String?
//                        var anchor: String? = call.argument("anchor")
        val visible: Boolean = (opts["visible"] as Boolean?)!!
        val draggable: Boolean = (opts["draggable"] as Boolean?)!!
        val alpha: Float = (opts["alpha"] as Double?)!!.toFloat()

        val marker = markerIdToMarker[id]!!
        marker.position = latLng
        marker.isVisible = visible
        marker.isDraggable = draggable
        marker.alpha = alpha

        val icon: Map<String, Any>? = (opts["icon"] as Map<String, Any>?)
        if (title != null) {
            marker.title = title
        }
        if (snippet != null) {
            marker.snippet = snippet
        }
        markerIdToOptions[marker.id] = opts
        if (icon != null) {
            when (icon["type"]) {
                "marker#asset" -> {
                    val size = icon["size"] as Map<String, Any>
                    val imageView = ImageView(context)
                    val params = ViewGroup.LayoutParams(size["width"] as Int, size["height"] as Int)
                    val assetManager: AssetManager = context.assets
                    imageView.setImageBitmap(BitmapFactory.decodeStream(assetManager.open(
                        FlutterInjector.instance().flutterLoader()
                            .getLookupKeyForAsset(icon["url"] as String)
                    )
                    )
                    )
                    imageView.layoutParams = params
                    val asset = BitmapDescriptorFactory.fromView(imageView)
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

    fun getInfoWindow(marker: Marker): View? {
        val id = marker.id
        val opts = markerIdToOptions[id]
        if (opts != null) {
            val infoWindow: Map<String, Any>? = (opts["infoWindow"] as Map<String, Any>?)
            if (infoWindow != null) {
                return null
            }
        }
        return null
    }

    fun onClick(marker: Marker): Boolean {
        val id = marker.id
        val markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            val params = hashMapOf<String, String>()
            params["markerId"] = markerId
            methodChannel.invokeMethod("marker#onTap", params)
            return true
        }
        return false
    }

    fun onDrag(marker: Marker, type: String) {
        val id = marker.id
        val markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            val params = hashMapOf<String, Any>()
            params["markerId"] = markerId
            params["latLng"] = Convert.toJson(marker.position)
            methodChannel.invokeMethod(type, params)
        }
    }
}