import 'package:amap_location_muka/amap_location_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';
import 'package:permission_handler/permission_handler.dart';

import 'amap_search.dart';
import 'create_amap/amap.dart';
import 'create_amap/interactive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AMapLocation.updatePrivacyAgree(true);
    AMapLocation.updatePrivacyShow(true, true);

    AMapLocation.setApiKey("6e630e675873f2a548f55ba99ee8c571", "56250708b9588800db63161534716f8c");

    [Permission.locationAlways, Permission.storage].request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Column(
              children: [
                ListItem(
                  title: Text('创建地图'),
                  showArrow: true,
                  color: Colors.white,
                  showDivider: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Amap()));
                  },
                ),
                ListItem(
                  title: Text('与地图交互'),
                  showArrow: true,
                  color: Colors.white,
                  showDivider: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Interactive()));
                  },
                ),
                ListItem(
                  title: Text('在地图上绘制'),
                  showArrow: true,
                  color: Colors.white,
                  showDivider: true,
                ),
                ListItem(
                  title: Text('获取地图数据'),
                  showArrow: true,
                  color: Colors.white,
                  showDivider: true,
                ),
                ListItem(
                  title: Text('当前位置'),
                  showArrow: true,
                  color: Colors.white,
                  showDivider: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AMapSearchLoc()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// ListItem(
//                   valueAlignment: Alignment.center,
//                   value: Text('添加marker'),
//                   onTap: () async {
//                     await _amapViewController.addMarker(
//                       AMapDefaultMarker(
//                         id: '1',
//                         position: LatLng(39.90607, 116.407041),
//                         draggable: true,
//                         title: '测试',
//                         snippet: '测试2222',
//                         icon: await AMapViewImage.asset(context, 'assets/images/map.png'),
//                         onTap: () {
//                           print('这是marker点击事件');
//                         },
//                         onDragStart: (latLng) {
//                           print('--------------------------');
//                           print('marker移动开始，当前坐标：${latLng.toJson()}');
//                         },
//                         onDragMove: (latLng) {
//                           print('marker移动中，当前坐标：${latLng.toJson()}');
//                         },
//                         onDragEnd: (latLng) {
//                           print('marker移动结束，当前坐标：${latLng.toJson()}');
//                         },
//                         showInfoWindow: true,
//                         infoWindow: AMapMarkerCardInfoWindow(),
//                       ),
//                     );
//                   },
//                 ),