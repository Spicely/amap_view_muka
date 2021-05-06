part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef void AmapViewOnCreated(AmapViewController controller);

class AmapView extends StatefulWidget {
  final dynamic creationParams;

  /// 地图初始化完成
  final AmapViewOnCreated? onCreated;

  const AmapView({
    Key? key,
    this.creationParams,
    this.onCreated,
  }) : super(key: key);

  @override
  _AmapViewState createState() => _AmapViewState();
}

class _AmapViewState extends State<AmapView> {
  late AmapViewController _controller;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        // gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: {
          'markers': [],
        },
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        layoutDirection: TextDirection.ltr,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        // gestureRecognizers: gestureRecognizers,
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
