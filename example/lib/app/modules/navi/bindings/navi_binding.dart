import 'package:get/get.dart';

import '../controllers/navi_controller.dart';

class NaviBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NaviController>(
      () => NaviController(),
    );
  }
}
