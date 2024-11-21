import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with AMapNaviListener {
  AMapNaviViewController aMapNaviViewController = AMapNaviViewController();

  @override
  void onInit() {
    super.onInit();
    aMapNaviViewController.addAMapNaviListener(this);
  }

  @override
  void onClose() {
    aMapNaviViewController.removeAMapNaviListener(this);
    super.onClose();
  }

  @override
  void onInitNaviSuccess() async {
    int strategy = await aMapNaviViewController.strategyConvert(true, false, false, false, false);
    AMapLocation location = await AMapViewServer.fetch();
    await aMapNaviViewController.calculateDriveRoute([location.latLng!], [], [LatLonPoint(116.29, 39.95)], strategy);
  }

  @override
  void onLocationChange(AMapNaviLocation? location) {
    print('-==============================');
    print(location?.toJson());
  }

  @override
  void onCalculateRouteSuccess(AMapCalcRouteResult routeResult) {
    print(2231312);
  }
}
