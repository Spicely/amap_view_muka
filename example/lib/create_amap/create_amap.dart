import 'package:amap_view_muka_example/create_amap/amap_my_loca.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/flutter_muka.dart';

import 'amap.dart';

class CreateAmap extends StatefulWidget {
  @override
  _CreateAmapState createState() => _CreateAmapState();
}

class _CreateAmapState extends State<CreateAmap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('创建地图'),
      ),
      body: ListView(
        children: [
          ListItem(
            title: Text('显示地图'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Amap()));
            },
          ),
          ListItem(
            title: Text('显示定位蓝点'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => AmapMyLoca()));
            },
          ),
          ListItem(
            title: Text('显示室内地图'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
          ),
          ListItem(
            title: Text('切换地图图层'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
          ),
          ListItem(
            title: Text('使用离线地图'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
          ),
          ListItem(
            title: Text('显示英文地图'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
          ),
          ListItem(
            title: Text('自定义地图'),
            showArrow: true,
            color: Colors.white,
            showDivider: true,
          ),
        ],
      ),
    );
  }
}
