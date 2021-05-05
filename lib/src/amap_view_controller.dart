part of amap_view_muka;

const _marker = 'plugins.muka.com/amap_view_muka_marker';

class AmapViewController {
  final int _id;

  MethodChannel _markerChannel;

  AmapViewController(this._id) : _markerChannel = MethodChannel('${_marker}_$_id');

  Future<void> addMarker(AmapViewMarker marker) async {
    print(marker.toJson());
    return _markerChannel.invokeMethod('marker#add', marker.toJson());
  }
}
