part of amap_view_muka;

const _markerChannel = 'plugins.muka.com/amap_view_muka_marker';

class AmapViewMarkerController {
  final int id;

  MethodChannel _channel;

  AmapViewMarkerController(String channel, this.id) : _channel = MethodChannel('$channel$id');
}
