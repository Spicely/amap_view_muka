part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef void AMapViewOnCreated(AMapViewController controller);

typedef void AMapViewOnMapClick(CameraPosition cameraPosition);

typedef void AMapViewOnMapMove(CameraPosition cameraPosition);

typedef void AMapViewOnMapIdle(CameraPosition cameraPosition);

class MyLocationStyle {
  final AMapLocationStyle locationStyle;

  final bool enabled;

  final int interval;

  final AMapImage? icon;

  final AMapAnchor? anchor;

  final Color? strokeColor;

  final Color? radiusFillColor;

  final double? strokeWidth;

  MyLocationStyle({
    required this.locationStyle,
    this.enabled = true,
    this.interval = 1000,
    this.icon,
    this.anchor,
    this.strokeColor,
    this.radiusFillColor,
    this.strokeWidth,
  });

  Map<String, dynamic> toJson() => {
        'locationStyle': locationStyle.index,
        'enabled': enabled,
        'interval': interval,
        'icon': icon?.toJson(),
        'anchor': anchor?.toJson(),
        'strokeColor':
            strokeColor != null ? [strokeColor!.value >> 16 & 0xFF, strokeColor!.value >> 8 & 0xFF, strokeColor!.value & 0xFF] : null,
        'radiusFillColor': radiusFillColor != null
            ? [radiusFillColor!.value >> 16 & 0xFF, radiusFillColor!.value >> 8 & 0xFF, radiusFillColor!.value & 0xFF]
            : null,
        'strokeWidth': strokeWidth,
      };
  MyLocationStyle copyWith({
    AMapLocationStyle? locationStyle,
    bool? enabled,
    int? interval,
    AMapImage? icon,
    AMapAnchor? anchor,
    Color? strokeColor,
    Color? radiusFillColor,
    double? strokeWidth,
  }) {
    return MyLocationStyle(
      locationStyle: locationStyle ?? this.locationStyle,
      enabled: enabled ?? this.enabled,
      interval: interval ?? this.interval,
      icon: icon ?? this.icon,
      anchor: anchor ?? this.anchor,
      strokeColor: strokeColor ?? this.strokeColor,
      radiusFillColor: radiusFillColor ?? this.radiusFillColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

class AMapView extends StatefulWidget {
  final dynamic creation;

  /// 地图初始化完成
  final AMapViewOnCreated? onCreated;

  /// 地图类型
  final AMapViewType? type;

  /// 地图语言
  final AMapViewLanguage? language;

  /// 缩放等级
  final double? zoom;

  /// markers
  final List<AMapMarker>? markers;

  /// polylines 折线
  final List<AMapPolyline>? polylines;

  /// 蓝点样式
  final MyLocationStyle? myLocationStyle;

  /// 室内地图
  final bool? indoorMap;

  /// 缩放按钮 [only Android]
  final bool? zoomControlsEnabled;

  /// 指南针
  final bool compassEnabled;

  /// 定位按钮 [only Android]
  final bool? myLocationButtonEnabled;

  /// 地图Logo位置
  final AMapViewLogoPosition? logoPosition;

  /// 缩放手势
  final bool? zoomGesturesEnabled;

  /// 滑动手势
  final bool? scrollGesturesEnabled;

  /// 旋转手势
  final bool? rotateGesturesEnabled;

  /// 倾斜手势
  final bool? tiltGesturesEnabled;

  /// 所有手势
  final bool? allGesturesEnabled;

  /// 地图显示位置
  final CameraPosition? cameraPosition;

  /// 指定屏幕中心点的手势操作 [only Android]
  final AMapPoint? pointToCenter;

  /// 点击地图
  final AMapViewOnMapClick? onMapClick;

  /// 地图移动
  final AMapViewOnMapMove? onMapMove;

  /// 地图移动结束
  final AMapViewOnMapIdle? onMapIdle;

  const AMapView({
    Key? key,
    this.creation,
    this.onCreated,
    this.type,
    this.language,
    this.zoom,
    this.myLocationStyle,
    this.indoorMap,
    this.zoomControlsEnabled,
    this.compassEnabled = false,
    this.myLocationButtonEnabled,
    this.logoPosition,
    this.zoomGesturesEnabled,
    this.allGesturesEnabled,
    this.rotateGesturesEnabled,
    this.scrollGesturesEnabled,
    this.tiltGesturesEnabled,
    this.cameraPosition,
    this.pointToCenter,
    this.onMapClick,
    this.onMapIdle,
    this.onMapMove,
    this.markers,
    this.polylines,
  }) : super(key: key);

  @override
  _AMapViewState createState() => _AMapViewState();
}

class _AMapViewState extends State<AMapView> {
  late AMapViewController _controller;
  bool _initialized = false;

  @override
  void didUpdateWidget(AMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_initialized) return;

    _syncMarkers(oldWidget.markers ?? [], widget.markers ?? []);
    _syncPolylines(oldWidget.polylines ?? [], widget.polylines ?? []);
  }

  void _syncMarkers(List<AMapMarker> oldMarkers, List<AMapMarker> newMarkers) {
    final oldMap = {for (final m in oldMarkers) m.id: m};
    final newMap = {for (final m in newMarkers) m.id: m};

    for (final oldId in oldMap.keys) {
      if (!newMap.containsKey(oldId)) {
        _controller.removeMarker(oldId);
      }
    }
    for (final entry in newMap.entries) {
      if (!oldMap.containsKey(entry.key)) {
        _controller.addMarker(entry.value);
      } else {
        _controller.updateMarker(entry.value);
      }
    }
  }

  void _syncPolylines(List<AMapPolyline> oldPolylines, List<AMapPolyline> newPolylines) {
    final oldMap = {for (final p in oldPolylines) p.id: p};
    final newMap = {for (final p in newPolylines) p.id: p};

    for (final oldId in oldMap.keys) {
      if (!newMap.containsKey(oldId)) {
        _controller.removePolyline(oldId);
      }
    }
    for (final entry in newMap.entries) {
      if (!oldMap.containsKey(entry.key)) {
        _controller.addPolyline(entry.value);
      } else {
        _controller.updatePolyline(entry.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    ].toSet();
    Map<String, dynamic> _creationParams = {
      'markers': widget.markers?.map((e) => e.toJson()).toList(),
      'polylines': widget.polylines?.map((e) => e.toJson()).toList(),
      'type': widget.type?.index,
      'language': widget.language?.index,
      'zoomLevel': widget.zoom,
      'myLocationStyle': widget.myLocationStyle?.toJson(),
      'indoorMap': widget.indoorMap,
      'zoomControlsEnabled': widget.zoomControlsEnabled,
      'compassEnabled': widget.compassEnabled,
      'myLocationButtonEnabled': widget.myLocationButtonEnabled,
      'logoPosition': widget.logoPosition?.index,
      'zoomGesturesEnabled': widget.zoomGesturesEnabled,
      'scrollGesturesEnabled': widget.scrollGesturesEnabled,
      'rotateGesturesEnabled': widget.rotateGesturesEnabled,
      'tiltGesturesEnabled': widget.tiltGesturesEnabled,
      'allGesturesEnabled': widget.allGesturesEnabled,
      'cameraPosition': widget.cameraPosition?.toJson(),
      'pointToCenter': widget.pointToCenter?.toJson(),
    };
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: _creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: TextDirection.ltr,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: _creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
  }

  void onPlatformViewCreated(int id) async {
    _controller = await AMapViewController.init(id, this);
    _initialized = true;

    /// 将参数marker加入缓存
    widget.markers?.forEach((marker) {
      _controller._markerMap[marker.id] = marker;
    });

    /// 将参数polyline加入缓存
    widget.polylines?.forEach((polyline) {
      _controller._polylineMap[polyline.id] = polyline;
    });

    widget.onCreated?.call(_controller);
  }
}

