import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class NaviController extends GetxController {
  AMapNaviViewController? aMapNaviViewController;

  @override
  void onInit() async {
    super.onInit();

    await [Permission.locationAlways, Permission.storage].request();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
