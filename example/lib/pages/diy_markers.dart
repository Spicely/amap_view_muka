import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

class DiyMarkers extends StatefulWidget {
  @override
  _DiyMarkersState createState() => _DiyMarkersState();
}

class _DiyMarkersState extends State<DiyMarkers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmapView(),
    );
  }
}
