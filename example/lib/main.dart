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
            onCreated: (amapViewController) {
              amapViewController.addMarker(
                AmapViewMarker(
                  id: '1',
                  position: LatLng(39.90607, 116.407041),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
