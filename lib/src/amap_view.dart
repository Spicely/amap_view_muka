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
    AmapLocationStyle? locationStyleParams,
    bool? enabledParams,
    int? intervalParams,
    AmapImage? iconParams,
    AmapAnchor? anchorParams,
    Color? strokeColorParams,
    Color? radiusFillColorParams,
    double? strokeWidthParams,
  }) {
    return MyLocationStyle(
      locationStyle: locationStyleParams ?? locationStyle,
      enabled: enabledParams ?? enabled,
      interval: intervalParams ?? interval,
      icon: iconParams ?? icon,
      anchor: anchorParams ?? anchor,
      strokeColor: strokeColorParams ?? strokeColor,
      radiusFillColor: radiusFillColorParams ?? radiusFillColor,
      strokeWidth: strokeWidthParams ?? strokeWidth,
    );
  }
}

class AmapView extends StatefulWidget {
  final dynamic creationParams;

  /// 地图初始化完成
  final AmapViewOnCreated? onCreated;

  /// 地图类型
  final AmapViewType? type;

  /// 地图语言
  final AmapViewLanguage? language;

  /// 缩放等级
  final double? zoomLevel;

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
    this.creationParams,
    this.onCreated,
    this.type,
    this.language,
    this.zoomLevel,
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

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: {
          'markers': [],
          'type': widget.type?.index,
          'language': widget.language?.index,
          'zoomLevel': widget.zoomLevel,
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
          'cameraPosition': widget.cameraPosition,
          'pointToCenter': widget.pointToCenter?.toJson(),
        },
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        layoutDirection: TextDirection.ltr,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        // onPlatformViewCreated: onPlatformViewCreated,
        // creationParams: creationParams,
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
