part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef void AmapViewOnCreated(AmapViewController controller);

typedef void AmapViewOnMapClick(CameraPosition cameraPosition);

typedef void AmapViewOnMapMove(CameraPosition cameraPosition);

typedef void AmapViewOnMapIdle(CameraPosition cameraPosition);

class MyLocationStyle {
  final AmapLocationStyle locationStyle;

  final bool enabled;

  final int interval;

  final AmapImage? icon;

  final AmapAnchor? anchor;

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
    AmapLocationStyle? locationStyle,
    bool? enabled,
    int? interval,
    AmapImage? icon,
    AmapAnchor? anchor,
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

class AmapView extends StatefulWidget {
  final dynamic creation;

  /// 地图初始化完成
  final AmapViewOnCreated? onCreated;

  /// 地图类型
  final AmapViewType? type;

  /// 地图语言
  final AmapViewLanguage? language;

  /// 缩放等级
  final double? zoom;

  /// markers
  final List<AmapMarker>? markers;

  /// 蓝点样式
  final MyLocationStyle? myLocationStyle;

  /// 室内地图
  final bool? indoorMap;

  /// 缩放按钮
  final bool? zoomControlsEnabled;

  /// 指南针
  final bool? compassEnabled;

  /// 定位按钮
  final bool? myLocationButtonEnabled;

  /// 地图Logo位置
  final AmapViewLogoPosition? logoPosition;

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

  final AmapPoint? pointToCenter;

  /// 点击地图
  final AmapViewOnMapClick? onMapClick;

  /// 地图移动
  final AmapViewOnMapMove? onMapMove;

  /// 地图移动结束
  final AmapViewOnMapIdle? onMapIdle;

  const AmapView({
    Key? key,
    this.creation,
    this.onCreated,
    this.type,
    this.language,
    this.zoom,
    this.myLocationStyle,
    this.indoorMap,
    this.zoomControlsEnabled,
    this.compassEnabled,
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
  }) : super(key: key);

  @override
  _AmapViewState createState() => _AmapViewState();
}

class _AmapViewState extends State<AmapView> {
  late AmapViewController _controller;

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    ].toSet();
    Map<String, dynamic> _creationParams = {
      'markers': widget.markers?.map((e) => e.toJson()).toList(),
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
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: _creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    }
  }

  void onPlatformViewCreated(int id) async {
    _controller = await AmapViewController.init(id, this);
    widget.onCreated?.call(_controller);
  }
}
