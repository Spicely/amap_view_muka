import 'package:amap_view_muka_example/pages/diy_markers.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

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
        body: DiyMarkers(),
        // body: ListView(
        //   children: [
        //     ElevatedButton(
        //       onPressed: () {
        //         Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => DiyMarkers()));
        //       },
        //       child: Text('自定义Marker'),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
