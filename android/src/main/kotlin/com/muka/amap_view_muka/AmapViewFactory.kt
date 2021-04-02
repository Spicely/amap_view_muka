package com.muka.amap_view_muka

import android.Manifest
import android.app.Activity
import android.content.Context
import android.util.Log
import android.view.View
import androidx.core.app.ActivityCompat
import com.amap.api.maps.AMap
import com.amap.api.maps.TextureMapView
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.CREATED
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.DESTROYED
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.PAUSED
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.RESUMED
import com.muka.amap_view_muka.AmapViewMukaPlugin.Companion.STOPPED
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.atomic.AtomicInteger

class AmapViewFactory(private val activity: Activity) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
        Log.d("11111111111","221111111111111111")
        // 申请权限
        ActivityCompat.requestPermissions(activity,
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.READ_PHONE_STATE),
                321
        )
        Log.d("11111111111","221144444444444444411111111111111")
        val params = args as Map<String, Any>
//        var opts = Convert.toUnifiedMapOptions(params["options"])
        var initialMarkers = params["markersToAdd"]
        return AMapView(context, viewId, initialMarkers)
    }
}

class AMapView(context: Context, id: Int,  private val initialMarkers: Any?) : PlatformView {
    private val mapView: TextureMapView = TextureMapView(context)

    private var map: AMap = mapView.map

    init {
        mapView.onCreate(null)
    }

    override fun getView(): View {
        return mapView
    }

//    fun setup() {
//        when (activityState.get()) {
//            STOPPED -> {
//                mapView.onCreate(null)
//                mapView.onResume()
//                mapView.onPause()
//            }
//            PAUSED -> {
//                mapView.onCreate(null)
//                mapView.onResume()
//                mapView.onPause()
//            }
//            RESUMED -> {
//                mapView.onCreate(null)
//                mapView.onResume()
//            }
//            CREATED -> mapView.onCreate(null)
//            DESTROYED -> {
//            }
//            else -> throw IllegalArgumentException(
//                    "Cannot interpret " + activityState.get() + " as an activity state")
//        } // Nothing to do, the activity has been completely destroyed.
//        active.application.registerActivityLifecycleCallbacks(this)
//    }


    override fun dispose() {
    }
}
