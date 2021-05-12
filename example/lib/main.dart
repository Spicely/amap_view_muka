import 'package:flutter/material.dart';
import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter_muka/flutter_muka.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AmapViewController _amapViewController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: AmapView(
                onCreated: (amapViewController) async {
                  _amapViewController = amapViewController;
                },
              ),
            ),
            Container(
              height: 320,
              child: ListView(
                children: [
                  ListItem(
                    valueAlignment: Alignment.center,
                    value: Text('添加marker'),
                    onTap: () async {
                      await _amapViewController.addMarker(
                        AmapDefaultMarker(
                          id: '1',
                          position: LatLng(39.90607, 116.407041),
                          draggable: true,
                          title: '测试',
                          snippet: '测试2222',
                          icon: await AmapMarkerImage.asset(context, 'assets/images/map.png'),
                          onTap: () {
                            print('这是marker点击事件');
                          },
                          onDragStart: (latLng) {
                            print('--------------------------');
                            print('marker移动开始，当前坐标：${latLng.toJson()}');
                          },
                          onDragMove: (latLng) {
                            print('marker移动中，当前坐标：${latLng.toJson()}');
                          },
                          onDragEnd: (latLng) {
                            print('marker移动结束，当前坐标：${latLng.toJson()}');
                          },
                          showInfoWindow: true,
                          infoWindow: AmapMarkerCardInfoWindow(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
