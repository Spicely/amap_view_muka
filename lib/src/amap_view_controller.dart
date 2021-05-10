part of amap_view_muka;

const _marker = 'plugins.muka.com/amap_view_muka_marker';

class AmapViewController {
  final Map<String, AmapMarker> _markerMap = {};

  late MethodChannel _markerChannel;

  AmapViewController._(this._markerChannel) {
    _markerChannel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AmapViewController> init(int id) async {
    MethodChannel markerChannel = MethodChannel('${_marker}_$id');
    return AmapViewController._(markerChannel);
  }

  /// 添加单个marker
  ///
  /// 已存在的id会被忽略
  Future<void> addMarker(AmapMarker marker) async {
    if (_markerMap[marker.id] == null) {
      _markerMap[marker.id] = marker;
      return _markerChannel.invokeMethod('marker#add', marker.toJson());
    }
    return Future.value(false);
  }

  /// 删除单个marker
  ///
  /// 不在的id会被忽略
  Future<void> removeMarker(String id) async {
    if (_markerMap[id] != null) {
      _markerMap.remove(id);
      return _markerChannel.invokeMethod('marker#delete', {'id': id});
    }
    return Future.value(false);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'marker#onTap':
        AmapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onTap?.call();
        }
        break;
      case 'marker#onDragStart':
        AmapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragStart?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      case 'marker#onDragMove':
        AmapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragMove?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      case 'marker#onDragEnd':
        AmapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragEnd?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      default:
        throw MissingPluginException();
    }
  }
}
