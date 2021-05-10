import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_view_muka/amap_view_muka.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';

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
        body: Container(
          height: double.infinity,
          child: AmapView(
            onCreated: (amapViewController) async {
              amapViewController.addMarker(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
