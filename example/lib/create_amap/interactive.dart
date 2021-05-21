import 'dart:io';

import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

class Interactive extends StatefulWidget {
  @override
  _InteractiveState createState() => _InteractiveState();
}

class _InteractiveState extends State<Interactive> {
  late AmapViewController _amapViewController;
  String? _path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('与地图交互'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                AmapView(
                  onCreated: (amapViewController) {
                    _amapViewController = amapViewController;
                  },
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setZoomControlsEnabled(true);
                          },
                          child: Text('显示缩放按钮'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setZoomControlsEnabled(false);
                          },
                          child: Text('隐藏缩放按钮'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setCompassEnabled(true);
                          },
                          child: Text('显示指南针'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setCompassEnabled(false);
                          },
                          child: Text('隐藏指南针'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMyLocationButtonEnabled(true);
                          },
                          child: Text('显示定位按钮'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMyLocationButtonEnabled(false);
                          },
                          child: Text('隐藏定位按钮'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setLogoPosition(AmapViewLogoPosition.LOGO_POSITION_BOTTOM_RIGHT);
                          },
                          child: Text('LOGO位置'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.animateCamera(
                              CameraPosition(LatLng(39.978719, 116.667966), 16, 20, 20),
                              duration: 200,
                            );
                          },
                          child: Text('移动视图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapStatusLimits(LatLng(33.789925, 104.838326), LatLng(38.740688, 114.647472));
                          },
                          child: Text('限制范围'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            String? path = await _amapViewController.getMapScreenShot();
                            if (path != null) {
                              setState(() {
                                _path = path;
                              });
                            }
                          },
                          child: Text('截图'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setZoomGesturesEnabled(true);
                          },
                          child: Text('打开缩放手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setZoomGesturesEnabled(false);
                          },
                          child: Text('关闭缩放手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print(await _amapViewController.getZoomGesturesEnabled());
                          },
                          child: Text('缩放手势状态'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setRotateGesturesEnabled(true);
                          },
                          child: Text('打开旋转手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setRotateGesturesEnabled(false);
                          },
                          child: Text('关闭旋转手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print(await _amapViewController.getRotateGesturesEnabled());
                          },
                          child: Text('旋转手势状态'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setTiltGesturesEnabled(true);
                          },
                          child: Text('打开倾斜手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setTiltGesturesEnabled(false);
                          },
                          child: Text('关闭倾斜手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            print(await _amapViewController.getTiltGesturesEnabled());
                          },
                          child: Text('倾斜手势状态'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setAllGesturesEnabled(true);
                          },
                          child: Text('打开所有手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setAllGesturesEnabled(false);
                          },
                          child: Text('关闭所有手势'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setPointToCenter(50, 50);
                            await _amapViewController.setGestureScaleByMapCenter(true);
                          },
                          child: Text('设置手势中心点'),
                        ),
                      ],
                    ),
                  ],
                ),
                _path == null ? Container() : Image.file(File(_path!), height: 200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
