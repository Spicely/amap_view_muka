import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

class Amap extends StatefulWidget {
  @override
  _AmapState createState() => _AmapState();
}

class _AmapState extends State<Amap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AmapView(),
    );
  }
}
