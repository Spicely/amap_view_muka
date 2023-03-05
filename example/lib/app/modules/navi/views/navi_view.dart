import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/navi_controller.dart';

class NaviView extends GetView<NaviController> {
  const NaviView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AMapNaviView(
        onListen: AmapNaviEventCallback(
          onCalculateRouteSuccess: (data) => print(data),
        ),
        params: AmapNaviParams(
          calculateType: AmapNaviCalculateType.drive,
          startToEnd: AmapNaviStartToEnd(
            start: AmapNaviLocationInfo(address: '', latLng: Get.arguments),
            end: AmapNaviLocationInfo(address: '', latLng: LatLng(30.555189, 104.274015)),
          ),
        ),
        onCreated: (AMapNaviViewController c) {
          controller.aMapNaviViewController = c;
        },
      ),
    );
  }
}
