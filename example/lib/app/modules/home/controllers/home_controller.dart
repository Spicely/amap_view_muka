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
    print('=================');
    int strategy = await aMapNaviViewController.strategyConvert(true, false, false, false, false);
    // await ac.calculateDriveRoute([], [], [], strategy);
    print('=================');
    print(strategy);
  }

  @override
  void onLocationChange(AMapNaviLocation? aMapNaviLocation) {
    print(aMapNaviLocation?.toJson());
  }
}
