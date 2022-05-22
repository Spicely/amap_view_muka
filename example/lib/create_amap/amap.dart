import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

class Amap extends StatefulWidget {
  @override
  _AmapState createState() => _AmapState();
}

class _AmapState extends State<Amap> {
  late AmapViewController _amapViewController;

  List<AmapMarker> _markers = [
    AmapDefaultMarker(
      id: '1',
      position: LatLng(30.572961, 104.066301),
    ),
    AmapDefaultMarker(
      id: '2',
      position: LatLng(30.573961, 104.066301),
      icon: AmapViewImage.asset('assets/images/map.png', size: AmapImageSize(height: 40, width: 40)),
    ),
  ];

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
                AmapView(
                  markers: _markers,
                  onCreated: (amapViewController) {
                    _amapViewController = amapViewController;
                  },
                  cameraPosition: CameraPosition(LatLng(30.572961, 104.066301), 15, 20, 45),
                  language: AmapViewLanguage.ENGLISH,
                  type: AmapViewType.MAP_TYPE_NIGHT,
                  // myLocationStyle: MyLocationStyle(
                  //   locationStyle: AmapLocationStyle.LOCATION_TYPE_FOLLOW,
                  //   enabled: true,
                  //   icon: AmapViewImage.asset('assets/images/map.png', size: AmapImageSize(height: 40, width: 40)),
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
                        //     await _amapViewController.setMapType(AmapViewType.MAP_TYPE_NAVI);
                        //   },
                        //   child: Text('导航地图'),
                        // ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AmapViewType.MAP_TYPE_NIGHT);
                          },
                          child: Text('夜景地图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AmapViewType.MAP_TYPE_NORMAL);
                          },
                          child: Text('白昼地图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AmapViewType.MAP_TYPE_SATELLITE);
                          },
                          child: Text('卫星图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapType(AmapViewType.MAP_TYPE_BUS);
                          },
                          child: Text('公交地图'),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapLanguage(AmapViewLanguage.CHINESE);
                          },
                          child: Text('中文'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMapLanguage(AmapViewLanguage.ENGLISH);
                          },
                          child: Text('英文'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setMyLocation(
                              locationStyle: AmapLocationStyle.LOCATION_TYPE_FOLLOW,
                              // anchor: AmapAnchor(0.0, 0),
                              strokeColor: Colors.blue,
                              radiusFillColor: Colors.blue.withOpacity(0.2),
                              strokeWidth: 300.0,
                              icon: AmapViewImage.asset(
                                'assets/images/map.png',
                                size: AmapImageSize(width: 100, height: 400),
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
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            AmapMarker newMarker = _markers[1].copyWith(
                              position: LatLng(30.602961, 104.066301),
                            );
                            print(newMarker.toJson());
                            await _amapViewController.updateMarker(newMarker);
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
