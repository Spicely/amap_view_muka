import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Amap extends StatefulWidget {
  @override
  _AMapState createState() => _AMapState();
}

class _AMapState extends State<Amap> {
  late AMapViewController _amapViewController;

  List<AMapMarker> _markers = [
    AMapDefaultMarker(
      id: '1',
      position: LatLng(30.572961, 104.066301),
    ),
    AMapDefaultMarker(
      id: '2',
      position: LatLng(30.573961, 104.066301),
      icon: AMapViewImage.asset('assets/images/map.png', size: AMapImageSize(height: 40, width: 40)),
    ),
  ];

  GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建地图'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                AMapView(
                  markers: _markers,
                  onCreated: (amapViewController) {
                    _amapViewController = amapViewController;
                  },
                  cameraPosition: CameraPosition(LatLng(30.572961, 104.066301), 15, 20, 45),
                  language: AMapViewLanguage.ENGLISH,
                  type: AMapViewType.MAP_TYPE_NIGHT,
                  // myLocationStyle: MyLocationStyle(
                  //   locationStyle: AMapLocationStyle.LOCATION_TYPE_FOLLOW,
                  //   enabled: true,
                  //   icon: AMapViewImage.asset('assets/images/map.png', size: AMapImageSize(height: 40, width: 40)),
                  //   radiusFillColor: Colors.red.withOpacity(0.2),
                  //   strokeColor: Colors.green,
                  //   strokeWidth: 3.0,
                  // ),
                  zoom: 18,
                  onMapClick: (cameraPosition) {
                    print('地图点击：${cameraPosition.toJson()}');
                  },
                  onMapMove: (cameraPosition) {
                    print('地图移动：${cameraPosition.toJson()}');
                  },
                  onMapIdle: (cameraPosition) {
                    print('地图移动结束：${cameraPosition.toJson()}');
                  },
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     await _amapViewController.setMapType(AMapViewType.MAP_TYPE_NAVI);
                        //   },
                        //   child: Text('导航地图'),
                        // ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AMapViewType.MAP_TYPE_NIGHT);
                          },
                          child: Text('夜景地图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AMapViewType.MAP_TYPE_NORMAL);
                          },
                          child: Text('白昼地图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AMapViewType.MAP_TYPE_SATELLITE);
                          },
                          child: Text('卫星图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AMapViewType.MAP_TYPE_BUS);
                          },
                          child: Text('公交地图'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapLanguage(AMapViewLanguage.CHINESE);
                          },
                          child: Text('中文'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapLanguage(AMapViewLanguage.ENGLISH);
                          },
                          child: Text('英文'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMyLocation(
                              locationStyle: AMapLocationStyle.LOCATION_TYPE_FOLLOW,
                              // anchor: AMapAnchor(0.0, 0),
                              strokeColor: Colors.blue,
                              radiusFillColor: Colors.blue.withOpacity(0.2),
                              strokeWidth: 300.0,
                              icon: AMapViewImage.asset(
                                'assets/images/map.png',
                                size: AMapImageSize(width: 100, height: 400),
                              ),
                            );
                          },
                          child: Text('显示蓝点'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setZoomLevel(18);
                            await _amapViewController.setIndoorMap(true);
                          },
                          child: Text('显示室内地图'),
                        ),
                      ],
                    ),
                    RepaintBoundary(
                      key: _globalKey,
                      child: Container(
                        alignment: Alignment.center,
                        height: 90,
                        width: 90,
                        color: Colors.red,
                        child: Column(
                          children: [
                            Text('123131'),
                            Text('1231313333'),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            RenderRepaintBoundary render = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
                            ui.Image image = await render.toImage();
                            ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
                            print(byteData?.buffer.asUint8List());
                            AMapMarker newMarker = AMapDefaultMarker(
                              id: '3',
                              position: LatLng(30.573961, 104.066301),
                              icon: AMapViewImage.uint8List(byteData!.buffer.asUint8List(), size: AMapImageSize(height: 90, width: 90)),
                            );
                            print(newMarker.toJson());
                            await _amapViewController.addMarker(newMarker);
                          },
                          child: Text('更新marker'),
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         await _amapViewController.disbleMyLocation();
                    //       },
                    //       child: Text('关闭蓝点'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         await _amapViewController.openOfflineMap();
                    //       },
                    //       child: Text('打开离线地图'),
                    //     ),
                    //     ElevatedButton(
                    //       onPressed: () async {
                    //         await _amapViewController.setOffLineCustomMapStyle('assets/style.data', 'assets/style_extra.data');
                    //       },
                    //       child: Text('设置离线地图'),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
