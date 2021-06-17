import 'package:amap_location_muka/amap_location_muka.dart';
import 'package:amap_view_muka/amap_view_muka.dart';
import 'package:flutter/material.dart';

class AmapSearch extends StatefulWidget {
  const AmapSearch({Key? key}) : super(key: key);

  @override
  _AmapSearchState createState() => _AmapSearchState();
}

class _AmapSearchState extends State<AmapSearch> {
  AmapViewController? _amapViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AmapView(
            onCreated: (amapViewController) async {
              _amapViewController = amapViewController;
              Location _loc = await AmapLocation.fetch();
              _amapViewController?.setCameraPosition(CameraPosition(LatLng(_loc.latitude!, _loc.longitude!), 13, 0, 20, duration: 200));
              _amapViewController?.addMarker(
                AmapDefaultMarker(
                  id: '1',
                  position: LatLng(_loc.latitude!, _loc.longitude!),
                  icon: AmapViewImage.asset('assets/images/map.png'),
                ),
              );
            },
            onMapClick: (_cameraPosition) async {
              print(_cameraPosition.toJson());
              bool? status = await _amapViewController?.updateMarker(
                AmapDefaultMarker(
                  id: '1',
                  position: _cameraPosition.latLng,
                ),
              );
              print(status);
            },
          ),
        ],
      ),
    );
  }
}
