import com.amap.api.maps.model.LatLngBounds
import com.amap.api.navi.model.AMapNaviCameraInfo
import com.amap.api.navi.model.AMapNaviForbiddenInfo
import com.amap.api.navi.model.AMapNaviLimitInfo
import com.amap.api.navi.model.AMapNaviRouteGuideGroup
import com.amap.api.navi.model.AMapNaviStep
import com.amap.api.navi.model.AMapRestrictionInfo
import com.amap.api.navi.model.AMapTrafficIncidentInfo
import com.amap.api.navi.model.AMapTrafficStatus
import com.amap.api.navi.model.NaviLatLng

class AMapNaviPath {
    var allLength: Int = 0
    var allTime: Int = 0
    var stepsCount: Int = 0
    var tollCost: Int = 0
    var routeType: Int = 0
    var pathid: Long = 0
    var mainRoadInfo: String? = null
    var centerForPath: NaviLatLng? = null
        private set
    var boundsForPath: LatLngBounds? = null
        private set
    var labelId: String? = null
    var labels: String? = null
    var wayPointIndex: IntArray
        private set
    var cityAdcodeList: IntArray
    var trafficStatuses: List<AMapTrafficStatus?> = ArrayList<Any?>()
        private set
    var steps: List<AMapNaviStep>? = null
    var coordList: List<NaviLatLng>? = null
        private set
    var startPoint: NaviLatLng? = null
    var endPoint: NaviLatLng? = null
    var carToFootPoint: NaviLatLng? = null
    var lightList: List<NaviLatLng>? = null
    private var wayPoi: List<NaviLatLng>? = null
    var allCameras: List<AMapNaviCameraInfo>? = null
        private set
    var restrictionInfo: AMapRestrictionInfo? = null
    var naviGuideList: List<AMapNaviRouteGuideGroup>? = null
    var trafficIncidentInfo: List<AMapTrafficIncidentInfo>? = null
    var limitInfos: List<AMapNaviLimitInfo>? = null
    var forbiddenInfos: List<AMapNaviForbiddenInfo>? = null

    fun setCameras(var1: List<AMapNaviCameraInfo>?) {
        this.allCameras = var1
    }

    fun setWayPointIndex(var1: Int, var2: Int) {
        wayPointIndex[var1] = var2
    }

    var wayPoint: List<NaviLatLng>?
        get() = this.wayPoi
        set(var1) {
            this.wayPoi = var1
            this.wayPointIndex = IntArray(var1!!.size)
        }

    fun setCenter(var1: NaviLatLng?) {
        this.centerForPath = var1
    }

    fun setBounds(var1: LatLngBounds?) {
        this.boundsForPath = var1
    }

    fun setList(var1: List<NaviLatLng>?) {
        this.coordList = var1
    }

    fun setTrafficStatus(var1: List<AMapTrafficStatus?>) {
        this.trafficStatuses = var1
    }

    val trafficLightCount: Int
        get() = if (this.lightList != null) lightList!!.size else 0
}
