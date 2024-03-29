part of amap_view_muka;

const _marker = 'plugins.muka.com/amap_view_muka_marker';

enum AMapViewType {
  /// 导航地图
  MAP_TYPE_NAVI,

  /// 夜景地图
  MAP_TYPE_NIGHT,

  /// 白昼地图（即普通地图）
  MAP_TYPE_NORMAL,

  /// 卫星图
  MAP_TYPE_SATELLITE,

  /// 公交地图
  MAP_TYPE_BUS,
}

enum AMapViewLogoPosition {
  /// 左边
  LOGO_POSITION_BOTTOM_LEFT,

  /// 底部
  LOGO_MARGIN_BOTTOM,

  /// 右边
  LOGO_MARGIN_RIGHT,

  /// 地图底部居中
  LOGO_POSITION_BOTTOM_CENTER,

  /// 地图右下角
  LOGO_POSITION_BOTTOM_RIGHT,
}

enum AMapViewLanguage {
  /// 中文
  CHINESE,

  /// 英文
  ENGLISH,
}

enum AMapLocationStyle {
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

class AMapAnchor {
  final double u;

  final double v;

  AMapAnchor(this.u, this.v);

  Map<String, dynamic> toJson() => {
        'u': this.u,
        'v': this.v,
      };

  AMapAnchor copyWith({
    double? u,
    double? v,
  }) =>
      AMapAnchor(u ?? this.u, v ?? this.v);

  factory AMapAnchor.fromJson(Map<String, dynamic> json) => AMapAnchor(json['u'], json['v']);
}

class AMapViewController {
  final Map<String, AMapMarker> _markerMap = {};

  late MethodChannel _markerChannel;

  late _AMapViewState _mapState;

  AMapViewController._(this._markerChannel, this._mapState) {
    _markerChannel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AMapViewController> init(int id, _AMapViewState state) async {
    MethodChannel markerChannel = MethodChannel('${_marker}_$id');
    return AMapViewController._(markerChannel, state);
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
    AMapLocationStyle locationStyle = AMapLocationStyle.LOCATION_TYPE_FOLLOW,
    bool enabled = true,
    int interval = 1000,
    AMapImage? icon,
    AMapAnchor? anchor,
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
  ///
  /// 地图的缩放级别一共分为 17 级，从 3 到 19。数字越大，展示的图面信息越精细。
  Future<void> setZoomLevel(double level) {
    return _markerChannel.invokeMethod('setZoomLevel', {'level': level});
  }

  /// 设置地图图层
  Future<void> setMapType(AMapViewType type) {
    return _markerChannel.invokeMethod('setMapType', {'type': type.index});
  }

  /// 设置地图语言
  Future<void> setMapLanguage(AMapViewLanguage language) {
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
  Future<bool?> addMarker(AMapMarker marker) async {
    if (_markerMap[marker.id] == null) {
      _markerMap[marker.id] = marker;
      return _markerChannel.invokeMethod('marker#add', marker.toJson());
    }
    return Future.value(false);
  }

  /// 更新单个marker
  ///
  /// 没有的id会返回false
  Future<bool?> updateMarker(AMapMarker marker) async {
    if (_markerMap[marker.id] != null) {
      return _markerChannel.invokeMethod('marker#update', marker.toJson());
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
        AMapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onTap?.call();
        }
        break;
      case 'marker#onDragStart':
        AMapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragStart?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      case 'marker#onDragMove':
        AMapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragMove?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      case 'marker#onDragEnd':
        AMapMarker? marker = _markerMap[call.arguments['markerId']];
        if (marker != null) {
          marker.onDragEnd?.call(LatLng.fromJson({
            'latitude': call.arguments['latLng']['latitude'],
            'longitude': call.arguments['latLng']['longitude'],
          }));
        }
        break;
      case 'map#onMapClick':
        _mapState.widget.onMapClick?.call(CameraPosition.fromJson(call.arguments));
        break;
      case 'map#onMapMove':
        _mapState.widget.onMapMove?.call(CameraPosition.fromJson(call.arguments));
        break;
      case 'map#onMapIdle':
        _mapState.widget.onMapIdle?.call(CameraPosition.fromJson(call.arguments));
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
  ///
  /// [package] 资源包来源
  Future<void> setOffLineCustomMapStyle(
    String dataPath,
    String extraPath, {
    String? texturePath,
    String? package,
  }) {
    return _markerChannel.invokeMethod('setOffLineCustomMapStyle', {
      'dataPath': dataPath,
      'extraPath': extraPath,
      'texturePath': texturePath,
      'package': package,
    });
  }

  /// 设置在线自定义地图
  ///
  /// [styleId] 样式ID
  ///
  /// [texturePath] 纹理图片(zip文件)
  ///
  /// [package] 资源包来源
  Future<void> setOnLineCustomMapStyle(
    String styleId, {
    String? texturePath,
    String? package,
  }) {
    return _markerChannel.invokeMethod('setOnLineCustomMapStyle', {
      'styleId': styleId,
      'texturePath': texturePath,
      'package': package,
    });
  }

  /// 缩放按钮
  Future<void> setZoomControlsEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setZoomControlsEnabled', {'enabled': enabled});
  }

  /// 指南针
  Future<void> setCompassEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setCompassEnabled', {'enabled': enabled});
  }

  /// 定位按钮
  Future<void> setMyLocationButtonEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setMyLocationButtonEnabled', {'enabled': enabled});
  }

  /// 地图Logo位置
  Future<void> setLogoPosition(AMapViewLogoPosition position) {
    return _markerChannel.invokeMethod('setLogoPosition', {'position': position.index});
  }

  /// 缩放手势
  Future<void> setZoomGesturesEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setZoomGesturesEnabled', {'enabled': enabled});
  }

  /// 滑动手势
  Future<void> setScrollGesturesEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setScrollGesturesEnabled', {'enabled': enabled});
  }

  /// 旋转手势
  Future<void> setRotateGesturesEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setRotateGesturesEnabled', {'enabled': enabled});
  }

  /// 倾斜手势
  Future<void> setTiltGesturesEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setTiltGesturesEnabled', {'enabled': enabled});
  }

  /// 所有手势
  Future<void> setAllGesturesEnabled(bool enabled) {
    return _markerChannel.invokeMethod('setAllGesturesEnabled', {'enabled': enabled});
  }

  /// 获取缩放手势状态
  Future<bool?> getZoomGesturesEnabled() {
    return _markerChannel.invokeMethod('getZoomGesturesEnabled');
  }

  /// 获取滑动手势状态
  Future<bool?> getScrollGesturesEnabled() {
    return _markerChannel.invokeMethod('getScrollGesturesEnabled');
  }

  /// 获取旋转手势状态
  Future<bool?> getRotateGesturesEnabled() {
    return _markerChannel.invokeMethod('getRotateGesturesEnabled');
  }

  /// 获取倾斜手势状态
  Future<bool?> getTiltGesturesEnabled() {
    return _markerChannel.invokeMethod('getTiltGesturesEnabled');
  }

  /// 设置以中心点进行手势
  Future<bool?> setGestureScaleByMapCenter(bool enabled) {
    return _markerChannel.invokeMethod('setGestureScaleByMapCenter', {'enabled': enabled});
  }

  /// 设置中心点
  ///
  /// [only Android]
  ///
  /// x、y均为屏幕坐标，屏幕左上角为坐标原点，即(0,0)点。
  Future<bool?> setPointToCenter(int x, int y) {
    return _markerChannel.invokeMethod('setPointToCenter', {'x': x, 'y': y});
  }

  /// 地图视角移动 [不传时间则无动画]
  ///
  /// [cameraPosition] 位置信息
  Future<void> animateCamera(CameraPosition cameraPosition) {
    return _markerChannel.invokeMethod('animateCamera', {
      'cameraPosition': cameraPosition.toJson(),
    });
  }

  /// 限制地图的显示范围
  ///
  /// [southwestLatLng] 位置信息
  ///
  /// [northeastLatLng] 位置信息
  Future<void> setMapStatusLimits(LatLng southwestLatLng, LatLng northeastLatLng) {
    return _markerChannel.invokeMethod('setMapStatusLimits', {
      'southwestLatLng': southwestLatLng.toJson(),
      'northeastLatLng': northeastLatLng.toJson(),
    });
  }

  /// 地图截屏
  Future<String?> getMapScreenShot(AMapShot shot) {
    return _markerChannel.invokeMethod('getMapScreenShot', {'shot': shot.toJson()});
  }

  /// 地图显示位置
  Future<bool?> setCameraPosition(CameraPosition cameraPosition) {
    return _markerChannel.invokeMethod('setCameraPosition', {'cameraPosition': cameraPosition.toJson()});
  }

  /// 经纬度算路
  ///
  /// [start]  起点信息
  ///
  /// [end]  终点信息
  ///
  /// [tactics] 经纬度算路 例：PathPlanningStrategy.DRIVING_DEFAULT
  ///
  /// [ways] 途经点信息
  Future<bool?> latLngCalculateDriveRoute(
    List<LatLng> start,
    List<LatLng> end,
    int tactics, {
    List<LatLng>? ways,
  }) {
    return _markerChannel.invokeMethod('latLngCalculateDriveRoute', {
      'start': start.map((e) => e.toJson()),
      'end': end.map((e) => e.toJson()),
      'ways': ways?..map((e) => e.toJson()),
      'tactics': tactics,
    });
  }
}

class AMapShot {
  final double x;

  final double y;

  final double width;

  final double height;

  final double compressionQuality;

  AMapShot({
    this.x = 0.0,
    this.y = 0.0,
    this.compressionQuality = 0.6,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
        'width': this.width * window.devicePixelRatio,
        'height': this.height * window.devicePixelRatio,
        'x': this.x,
        'y': this.y,
        'compressionQuality': this.compressionQuality,
      };
}
