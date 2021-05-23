part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef void AmapViewOnCreated(AmapViewController controller);

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

  const AmapView({
    Key? key,
    this.creationParams,
    this.onCreated,
    this.type,
    this.language,
    this.zoomLevel,
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
          'index': widget.language?.index,
          'zoomLevel': widget.zoomLevel,
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
