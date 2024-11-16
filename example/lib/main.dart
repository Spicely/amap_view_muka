import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AMapViewServer.updatePrivacyAgree(true);
  await AMapViewServer.updatePrivacyShow(true, true);
  await AMapViewServer.setApiKey("6e630e675873f2a548f55ba99ee8c571", "56250708b9588800db63161534716f8c");
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
