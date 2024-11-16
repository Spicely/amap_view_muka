part of '../../amap_view_muka.dart';

class CoreRouteDashedLineColor {
  // Add properties and methods as per the Java code's use case
}

class CoreRoutePassLineColor {
  // Add properties and methods as per the Java code's use case
}

class CoreRouteTrafficStatusColor {
  // Add properties and methods as per the Java code's use case
}

class RouteOverlayOptions {
  Image? smoothTraffic;
  Image? unknownTraffic;
  Image? slowTraffic;
  Image? jamTraffic;
  Image? veryJamTraffic;
  Image? arrowOnRoute;
  Image? normalRoute;
  Image? passRoute;
  Image? fairWayRes;
  Image? passFairWayRes;

  int arrowSideColor = -15505201;
  int arrowColor = -1;
  bool isTurnArrow3D = true;
  bool isShowCameOnRoute = true;
  Rect? rect;
  double lineWidth = 0.0;
  CoreRouteDashedLineColor? dashedLineColor;
  CoreRoutePassLineColor? passedRouteColor;
  List<CoreRouteTrafficStatusColor> routeStatusColor = [];

  RouteOverlayOptions();

  // Getter and Setter Methods
  Image? getFairWayRes() => fairWayRes;
  setFairWayRes(Image? image) => fairWayRes = image;

  Image? getPassRoute() => passRoute;
  setPassRoute(Image? image) => passRoute = image;

  Image? getPassFairWayRes() => passFairWayRes;
  setPassFairWayRes(Image? image) => passFairWayRes = image;

  Rect? getRect() => rect;
  setRect(Rect? rectangle) => rect = rectangle;

  setOnRouteCameShow(bool show) => isShowCameOnRoute = show;

  int getArrowColor() => arrowColor;
  setArrowColor(int color) => arrowColor = color;

  Image? getVeryJamTraffic() => veryJamTraffic;
  setVeryJamTraffic(Image? image) => veryJamTraffic = image;

  Image? getSmoothTraffic() => smoothTraffic;
  setSmoothTraffic(Image? image) => smoothTraffic = image;

  Image? getUnknownTraffic() => unknownTraffic;
  setUnknownTraffic(Image? image) => unknownTraffic = image;

  Image? getSlowTraffic() => slowTraffic;
  setSlowTraffic(Image? image) => slowTraffic = image;

  Image? getJamTraffic() => jamTraffic;
  setJamTraffic(Image? image) => jamTraffic = image;

  Image? getArrowOnTrafficRoute() => arrowOnRoute;
  setArrowOnTrafficRoute(Image? image) => arrowOnRoute = image;

  Image? getNormalRoute() => normalRoute;
  setNormalRoute(Image? image) => normalRoute = image;

  double getLineWidth() => lineWidth;
  setLineWidth(double width) => lineWidth = width;

  bool isTurnArrowIs3D() => isTurnArrow3D;
  setTurnArrowIs3D(bool is3D) => isTurnArrow3D = is3D;

  int getArrowSideColor() => arrowSideColor;
  setArrowSideColor(int color) => arrowSideColor = color;

  CoreRouteDashedLineColor? getDashedLineColor() => dashedLineColor;
  setDashedLineColor(CoreRouteDashedLineColor? color) => dashedLineColor = color;

  CoreRoutePassLineColor? getRouteGreyColor() => passedRouteColor;
  setRouteGreyColor(CoreRoutePassLineColor? color) => passedRouteColor = color;

  List<CoreRouteTrafficStatusColor> getRouteStatusColor() => routeStatusColor;
  setRouteStatusColor(List<CoreRouteTrafficStatusColor> colors) => routeStatusColor = colors;
}
