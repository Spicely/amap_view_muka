part of '../../amap_view_muka.dart';

mixin AMapNaviListener {
  void onInitNaviFailure() {}

  void onInitNaviSuccess() {}

  void onStartNavi(int type) {}

  void onTrafficStatusUpdate() {}

  void onLocationChange(AMapNaviLocation? location) {}

  void onGetNavigationText(int type, String? text) {}

  // void onGetNavigationText(String text) {}

  void onEndEmulatorNavi() {}

  void onArriveDestination() {}

  // void onCalculateRouteFailure(int errorInfo) {}

  void onReCalculateRouteForYaw() {}

  void onReCalculateRouteForTrafficJam() {}

  void onArrivedWayPoint(int wayID) {}

  void onGpsOpenStatus(bool enabled) {}

  void onNaviInfoUpdate(NaviInfo naviInfo) {}

  void updateCameraInfo(List<AMapNaviCameraInfo> infoArray) {}

  void updateIntervalCameraInfo(AMapNaviCameraInfo startCameraInfo, AMapNaviCameraInfo endCameraInfo, int status) {}

  void onServiceAreaUpdate(List<AMapServiceAreaInfo> infoArray) {}

  void showCross(AMapNaviCross aMapNaviCross) {}

  void hideCross() {}

  void showModeCross(AMapModelCross modelCross) {}

  void hideModeCross() {}

  void showLaneInfo(List<AMapLaneInfo> laneInfos, List<int> laneBackgroundInfo, List<int> laneRecommendedInfo) {}

  // void showLaneInfo(AMapLaneInfo var1) {}

  void hideLaneInfo() {}

  // void onCalculateRouteSuccess(List<int> var1) {}

  // void notifyParallelRoad(int var1) {}

  void onUpdateTrafficFacility(List<AMapNaviTrafficFacilityInfo> infos) {}

  // void onUpdateTrafficFacility(AMapNaviTrafficFacilityInfo aMapNaviTrafficFacilityInfo) {}

  void updateAimlessModeStatistics(AimLessModeStat aimLessModeStat) {}

  void updateAimlessModeCongestionInfo(AimLessModeCongestionInfo aimLessModeCongestionInfo) {}

  void onPlayRing(int type) {}

  void onCalculateRouteSuccess(AMapCalcRouteResult routeResult) {}

  void onCalculateRouteFailure(AMapCalcRouteResult routeResult) {}

  void onNaviRouteNotify(AMapNaviRouteNotifyData notifyData) {}

  void onGpsSignalWeak(bool isWeak) {}
}
