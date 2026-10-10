package com.muka.amap_view_muka

import android.graphics.Color
import com.amap.api.maps.AMap
import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Polyline
import com.amap.api.maps.model.PolylineOptions
import io.flutter.plugin.common.MethodChannel

class PolylineController(private val methodChannel: MethodChannel, private val map: AMap) :
    AMap.OnPolylineClickListener {

    // dartPolylineId -> Polyline
    private val dartIdToPolyline = HashMap<String, Polyline>()
    // AMap SDK polyline.id -> dartPolylineId
    private val polylineIdToDartId = HashMap<String, String>()

    fun addPolyline(opts: Map<String, Any>) {
        val id = opts["id"] as? String ?: return
        if (dartIdToPolyline.containsKey(id)) {
            updatePolyline(opts)
            return
        }

        val options = buildPolylineOptions(opts) ?: return
        val polyline = map.addPolyline(options)
        dartIdToPolyline[id] = polyline
        polylineIdToDartId[polyline.id] = id
    }

    fun updatePolyline(opts: Map<String, Any>) {
        val id = opts["id"] as? String ?: return
        val polyline = dartIdToPolyline[id] ?: run {
            addPolyline(opts)
            return
        }

        val pointsList = opts["points"] as? List<Map<String, Any>>
        if (pointsList != null) {
            val points = pointsList.map {
                LatLng((it["latitude"] as Number).toDouble(), (it["longitude"] as Number).toDouble())
            }
            polyline.points = points
        }

        val width = opts["width"] as? Number
        if (width != null) {
            polyline.width = width.toFloat()
        }

        val color = parseColor(opts)
        if (color != null) {
            polyline.color = color
        }

        val visible = opts["visible"] as? Boolean
        if (visible != null) {
            polyline.isVisible = visible
        }

        val zIndex = opts["zIndex"] as? Number
        if (zIndex != null) {
            polyline.zIndex = zIndex.toFloat()
        }

        val isDotted = opts["isDotted"] as? Boolean
        if (isDotted != null) {
            polyline.isDottedLine = isDotted
        }

        val isGeodesic = opts["isGeodesic"] as? Boolean
        if (isGeodesic != null) {
            polyline.isGeodesic = isGeodesic
        }
    }

    fun deletePolyline(opts: Map<String, Any>) {
        val id = opts["id"] as? String ?: return
        val polyline = dartIdToPolyline.remove(id)
        if (polyline != null) {
            polylineIdToDartId.remove(polyline.id)
            polyline.remove()
        }
    }

    fun clearPolylines() {
        for (polyline in dartIdToPolyline.values) {
            polyline.remove()
        }
        dartIdToPolyline.clear()
        polylineIdToDartId.clear()
    }

    private fun buildPolylineOptions(opts: Map<String, Any>): PolylineOptions? {
        val pointsList = opts["points"] as? List<Map<String, Any>> ?: return null
        val points = pointsList.map {
            LatLng((it["latitude"] as Number).toDouble(), (it["longitude"] as Number).toDouble())
        }
        if (points.isEmpty()) return null

        val options = PolylineOptions()
        options.addAll(points)

        val width = (opts["width"] as? Number)?.toFloat() ?: 10f
        options.width(width)

        val color = parseColor(opts) ?: Color.parseColor("#00E676")
        options.color(color)

        val visible = (opts["visible"] as? Boolean) ?: true
        options.visible(visible)

        val zIndex = (opts["zIndex"] as? Number)?.toFloat() ?: 0f
        options.zIndex(zIndex)

        val isDotted = (opts["isDotted"] as? Boolean) ?: false
        options.setDottedLine(isDotted)

        val isGeodesic = (opts["isGeodesic"] as? Boolean) ?: false
        options.geodesic(isGeodesic)

        when ((opts["lineJoinType"] as? Number)?.toInt()) {
            0 -> options.lineJoinType(PolylineOptions.LineJoinType.LineJoinBevel)
            1 -> options.lineJoinType(PolylineOptions.LineJoinType.LineJoinMiter)
            else -> options.lineJoinType(PolylineOptions.LineJoinType.LineJoinRound)
        }

        when ((opts["lineCapType"] as? Number)?.toInt()) {
            0 -> options.lineCapType(PolylineOptions.LineCapType.LineCapButt)
            1 -> options.lineCapType(PolylineOptions.LineCapType.LineCapSquare)
            else -> options.lineCapType(PolylineOptions.LineCapType.LineCapRound)
        }

        return options
    }

    private fun parseColor(opts: Map<String, Any>): Int? {
        val colorValue = opts["colorValue"] as? Number
        if (colorValue != null) {
            return colorValue.toInt()
        }
        val colorList = opts["color"] as? List<Number>
        if (colorList != null && colorList.size >= 4) {
            return Color.argb(
                colorList[3].toInt(),
                colorList[0].toInt(),
                colorList[1].toInt(),
                colorList[2].toInt()
            )
        }
        return null
    }

    override fun onPolylineClick(polyline: Polyline) {
        val dartId = polylineIdToDartId[polyline.id] ?: return
        val arguments = HashMap<String, Any>()
        arguments["polylineId"] = dartId
        methodChannel.invokeMethod("polyline#onTap", arguments)
    }
}
