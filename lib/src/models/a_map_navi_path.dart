part of '../../amap_view_muka.dart';

class AMapNaviPath {
  int allLength = 0;
  int allTime = 0;
  int stepsCount = 0;
  int tollCost = 0;
  int routeType = 0;
  int pathid = 0;
  String? mainRoadInfo;
  NaviLatLng? centerForPath;
  LatLngBounds? boundsForPath;
  String? labelId;
  String? labels;
  List<int> wayPointIndex = [];
  List<int> cityAdcodeList = [];
  List<AMapTrafficStatus?> trafficStatuses = [];
  List<AMapNaviStep>? steps;
  List<NaviLatLng>? coordList;
  NaviLatLng? startPoint;
  NaviLatLng? endPoint;
  NaviLatLng? carToFootPoint;
  List<NaviLatLng>? lightList;
  List<NaviLatLng>? wayPoint;
  List<AMapNaviCameraInfo>? allCameras;
  AMapRestrictionInfo? restrictionInfo;
  List<AMapNaviRouteGuideGroup>? naviGuideList;
  List<AMapTrafficIncidentInfo>? trafficIncidentInfo;
  List<AMapNaviLimitInfo>? limitInfos;
  List<AMapNaviForbiddenInfo>? forbiddenInfos;
  int trafficLightCount = 0;
}

// Dummy classes to match types in the Kotlin code.
class NaviLatLng {
  double latitude;
  double longitude;
  NaviLatLng(this.latitude, this.longitude);
}

class LatLngBounds {
  double southwestLatitude;
  double southwestLongitude;
  double northeastLatitude;
  double northeastLongitude;
  LatLngBounds(this.southwestLatitude, this.southwestLongitude, this.northeastLatitude, this.northeastLongitude);
}

class AMapTrafficStatus {}

class AMapNaviStep {}

class AMapRestrictionInfo {}

class AMapNaviRouteGuideGroup {}

class AMapTrafficIncidentInfo {}

class AMapNaviLimitInfo {}

class AMapNaviForbiddenInfo {}
