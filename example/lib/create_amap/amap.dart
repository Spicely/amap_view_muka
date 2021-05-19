import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

class Amap extends StatefulWidget {
  @override
  _AmapState createState() => _AmapState();
}

class _AmapState extends State<Amap> {
  late AmapViewController _amapViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('显示蓝点'),
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
                            await _amapViewController.setMapType(AmapViewType.MAP_TYPE_NAVI);
                          },
                          child: Text('导航地图'),
                        ),
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
                            await _amapViewController.disbleMyLocation();
                          },
                          child: Text('关闭蓝点'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.openOfflineMap();
                          },
                          child: Text('打开离线地图'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _amapViewController.setOfflineCustomMapStyle('assets/style.data', 'assets/style_extra.data');
                            print(111);
                          },
                          child: Text('设置离线地图'),
                        ),
                      ],
                    ),
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
