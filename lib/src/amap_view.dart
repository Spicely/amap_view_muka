part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef void AmapViewOnCreated(AmapViewController controller);

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

  const AmapView({
    Key? key,
    this.creationParams,
    this.onCreated,
    this.type,
    this.language,
    this.zoomLevel,
    this.myLocationStyle,
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
          'myLocationStyle': widget.myLocationStyle?.toJson()
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
    _controller = await AmapViewController.init(id);
    widget.onCreated?.call(_controller);
  }
}
