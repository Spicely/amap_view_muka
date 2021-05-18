import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

class AmapMyLoca extends StatefulWidget {
  @override
  _AmapMyLocaState createState() => _AmapMyLocaState();
}

class _AmapMyLocaState extends State<AmapMyLoca> {
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
            child: AmapView(
              onCreated: (amapViewController) {
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
                  value: Text('显示蓝点'),
                  onTap: () async {
                    await _amapViewController.setMyLocation(
                      locationStyle: AmapLocationStyle.LOCATION_TYPE_LOCATION_ROTATE,
                      // anchor: AmapAnchor(0.4, 0),
                      strokeColor: Colors.blue,
                      radiusFillColor: Colors.blue.withOpacity(0.2),
                      strokeWidth: 300.0,
                      icon: await AmapViewImage.asset(
                        context,
                        'assets/images/map.png',
                        size: AmapImageSize(width: 100, height: 400),
                      ),
                    );
                  },
                ),
                ListItem(
                  valueAlignment: Alignment.center,
                  value: Text('关闭蓝点'),
                  onTap: () async {
                    await _amapViewController.disbleMyLocation();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
