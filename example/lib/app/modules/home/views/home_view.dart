import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AMapNaviView(
            controller: controller.aMapNaviViewController,
            initParams: const AmapNaviParams(
              viewOptions: AMapNaviViewOptions(isLayoutVisible: false),
              aMap: AMap(isMyLocationEnabled: true, uiSettings: UiSettings()),
            ),
          ),
          // AMapView(),
          Positioned(
            bottom: 220,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () async {
                PoiResult pois = await AMapViewServer.searchKeyword('广场', city: '成都', page: 1, pageSize: 10);
                print(pois.toJson());
              },
              child: const Text('样式设置'),
            ),
          ),
        ],
      ),
    );
  }
}
