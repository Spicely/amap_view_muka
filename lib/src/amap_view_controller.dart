part of amap_view_muka;

const _marker = 'plugins.muka.com/amap_view_muka_marker';

class AmapViewController {
  final List<String> _markerIds = [];

  late MethodChannel _markerChannel;

  AmapViewController._(this._markerChannel) {
    _markerChannel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AmapViewController> init(int id) async {
    MethodChannel markerChannel = MethodChannel('${_marker}_$id');
    return AmapViewController._(markerChannel);
  }

  Future<void> addMarker(AmapMarker marker) async {
    if (_markerIds.indexOf(marker.id) == -1) {
      _markerIds.add(marker.id);
      return _markerChannel.invokeMethod('marker#add', marker.toJson());
    }
    return Future.value(false);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'marker#onTap':
        print('marker#onTap');
        break;
      default:
        throw MissingPluginException();
    }
  }
}
