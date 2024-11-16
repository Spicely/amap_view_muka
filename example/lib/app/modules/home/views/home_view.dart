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
              initParams: const AmapNaviParams(
                viewOptions: AMapNaviViewOptions(isLayoutVisible: false),
                aMap: AMap(isMyLocationEnabled: true, uiSettings: UiSettings()),
              ),
              onCreated: (AMapNaviViewController aMapNaviViewController) {
                controller.aMapNaviViewController = aMapNaviViewController;
              },
            ),
            // AMapView(),
            // Positioned(
            //   bottom: 220,
            //   left: 20,
            //   right: 20,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       AMapNaviViewOptions options = AMapNaviViewOptions();
            //       options.isLayoutVisible = true;

            //       controller.aMapNaviViewController.viewOptions = options;
            //     },
            //     child: const Text('样式设置'),
            //   ),
            // ),
          ],
        ));
  }
}
