package com.muka.amap_view_muka

import android.app.Activity
import android.app.Application
import android.os.Bundle
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry
import java.util.concurrent.atomic.AtomicInteger

/** AmapViewMukaPlugin */
class AmapViewMukaPlugin : FlutterPlugin, ActivityAware, Application.ActivityLifecycleCallbacks {
    private val state = AtomicInteger(0)
    private val registrarActivityHashCode: Int

    private var activity: Activity? = null

    companion object {
        private const val TAG_FLUTTER_FRAGMENT = "plugins.muka.com/amap_view_muka"

        internal const val CREATED = 1

        // internal val STARTED = 2
        internal const val RESUMED = 3
        internal const val PAUSED = 4
        internal const val STOPPED = 5
        internal const val DESTROYED = 6

        @JvmStatic
        fun registerWith(registrar: PluginRegistry.Registrar) {
            registrar.platformViewRegistry().registerViewFactory(TAG_FLUTTER_FRAGMENT, AmapViewFactory(registrar.activity()))
        }

    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {

        binding.platformViewRegistry.registerViewFactory(TAG_FLUTTER_FRAGMENT, AmapViewFactory(binding.applicationContext as Activity))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(CREATED)
    }

    override fun onActivityStarted(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivityResumed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(RESUMED)
    }

    override fun onActivityPaused(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(PAUSED)
    }

    override fun onActivityStopped(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(STOPPED)
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {}

    override fun onActivityDestroyed(activity: Activity) {
        if (activity.hashCode() != registrarActivityHashCode) {
            return
        }
        state.set(DESTROYED)
    }

    init {
        this.registrarActivityHashCode = activity.hashCode()
    }
}
