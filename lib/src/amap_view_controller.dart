part of amap_view_muka;

const _marker = 'plugins.muka.com/amap_view_muka_marker';

enum AmapViewType {
  /// 导航地图
  MAP_TYPE_NAVI,

  /// 夜景地图
  MAP_TYPE_NIGHT,

  /// 白昼地图（即普通地图）
  MAP_TYPE_NORMAL,

  /// 卫星图
  MAP_TYPE_SATELLITE,
}

enum AmapViewLanguage {
  /// 中文
  CHINESE,

  /// 英文
  ENGLISH,
}

enum AmapLocationStyle {
  /// 只定位一次 地图不会移动
  LOCATION_TYPE_SHOW,

  ///定位一次，且将视角移动到地图中心点
  LOCATION_TYPE_LOCATE,

  /// 连续定位、且将视角移动到地图中心点，定位蓝点跟随设备移动。（1秒1次定位）
  LOCATION_TYPE_FOLLOW,

  /// 连续定位、且将视角移动到地图中心点，地图依照设备方向旋转，定位点会跟随设备移动。（1秒1次定位）
  LOCATION_TYPE_MAP_ROTATE,

  /// 连续定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动。（1秒1次定位）默认执行此种模式
  LOCATION_TYPE_LOCATION_ROTATE,

  /// 连续定位、蓝点不会移动到地图中心点，定位点依照设备方向旋转，并且蓝点会跟随设备移动
  LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER,

  /// 连续定位、蓝点不会移动到地图中心点，并且蓝点会跟随设备移动。
  LOCATION_TYPE_FOLLOW_NO_CENTER,

  /// 连续定位、蓝点不会移动到地图中心点，地图依照设备方向旋转，并且蓝点会跟随设备移动
  LOCATION_TYPE_MAP_ROTATE_NO_CENTER,
}

class AmapAnchor {
  final double u;

  final double v;

  AmapAnchor(this.u, this.v);

  Map<String, dynamic> toJson() => {
        'u': this.u,
        'v': this.v,
      };

  AmapAnchor copyWith({
    double? uParam,
    double? vParam,
  }) =>
      AmapAnchor(uParam ?? u, vParam ?? v);

  factory AmapAnchor.fromJson(Map<String, dynamic> json) => AmapAnchor(json['u'], json['v']);
}

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

  /// 设置蓝点 并开启
  ///
  /// [locationStyle] 蓝点的处理样式
  ///
  /// [enabled] 显示蓝点
  ///
  /// [interval] 设置定位频次方法，单位：毫秒，默认值：1000毫秒，如果传小于1000的任何值将按照1000计算。该方法只会作用在会执行连续定位的工作模式上
  ///
  /// [icon] 自定义图标
  Future<void> setMyLocation({
    AmapLocationStyle locationStyle = AmapLocationStyle.LOCATION_TYPE_FOLLOW,
    bool enabled = true,
    int interval = 1000,
    AmapImage? icon,
    AmapAnchor? anchor,
    Color? strokeColor,
    Color? radiusFillColor,
    double? strokeWidth,
  }) async {
    return _markerChannel.invokeMethod('enabledMyLocation', {
      'locationStyle': locationStyle.index,
      'enabled': enabled,
      'interval': interval,
      'icon': icon?.toJson(),
      'anchor': anchor?.toJson(),
      'strokeColor': strokeColor != null ? [strokeColor.value >> 16 & 0xFF, strokeColor.value >> 8 & 0xFF, strokeColor.value & 0xFF] : null,
      'radiusFillColor': radiusFillColor != null
          ? [radiusFillColor.value >> 16 & 0xFF, radiusFillColor.value >> 8 & 0xFF, radiusFillColor.value & 0xFF]
          : null,
      'strokeWidth': strokeWidth,
    });
  }

  /// 关闭蓝点
  Future<void> disbleMyLocation() {
    return _markerChannel.invokeMethod('disbleMyLocation');
  }

  /// 设置缩放等级
  Future<void> setZoomLevel(double level) {
    return _markerChannel.invokeMethod('setZoomLevel', {'level': level});
  }

  /// 设置地图图层
  Future<void> setMapType(AmapViewType type) {
    return _markerChannel.invokeMethod('setMapType', {'type': type.index});
  }

  /// 设置地图语言
  Future<void> setMapLanguage(AmapViewLanguage language) {
    return _markerChannel.invokeMethod('setMapLanguage', {'language': language.index});
  }

  /// 设置室内地图显示
  Future<void> setIndoorMap(bool enabled) {
    return _markerChannel.invokeMethod('setIndoorMap', {'enabled': enabled});
  }

  /// 设置室内位置
  ///
  /// [latLng] 定位点的经纬度
  ///
  /// [floorNo] 定位点的楼层号
  ///
  /// [direction] 定位点的方向
  ///
  /// [accuracy] 	定位点的精度
  Future<void> setLocatingPosition(
    LatLng latLng,
    int floorNo,
    double direction,
    double accuracy,
  ) {
    return _markerChannel.invokeMethod('setLocatingPosition', {
      'latLng': latLng.toJson(),
      'floorNo': floorNo,
      'direction': direction,
      'accuracy': accuracy,
    });
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
  /// 不存在的id会被忽略
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

  /// 打开离线地图  [使用官方提供的UI]
  Future<void> openOfflineMap() {
    return _markerChannel.invokeMethod('openOfflineMap');
  }

  /// 设置离线自定义地图
  ///
  /// [dataPath] 具体样式配置
  ///
  /// [extraPath] 扩展内容，如网格背景色等
  ///
  /// [texturePath] 纹理图片(zip文件)
  Future<void> setOfflineCustomMapStyle(
    String dataPath,
    String extraPath, {
    String? texturePath,
  }) {
    return _markerChannel.invokeMethod('setOfflineCustomMapStyle', {
      'dataPath': dataPath,
      'extraPath': extraPath,
      'texturePath': texturePath,
    });
  }
}
