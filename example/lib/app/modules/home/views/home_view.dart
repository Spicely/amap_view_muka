import 'dart:typed_data';

import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            // Obx(
            //   () => controller.headedBitmap == null ? Container() : Image.memory(controller.headedBitmap.value!),
            // ),
            // Image.memory(Uint8List.fromList(controller.value)),
            ElevatedButton(
              child: Text('导航'),
              onPressed: () async {
                Location loc = await AMapViewServer.fetch();
                Get.toNamed(Routes.NAVI, arguments: LatLng(loc.latitude!, loc.longitude!));
              },
            ),
          ],
        ),
      ),
    );
  }
}
