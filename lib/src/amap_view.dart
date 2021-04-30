part of amap_view_muka;

const _viewType = 'plugins.muka.com/amap_view_muka';

class AmapView extends StatefulWidget {
  final dynamic creationParams;

  const AmapView({
    Key? key,
    this.creationParams,
  }) : super(key: key);

  @override
  _AmapViewState createState() => _AmapViewState();
}

class _AmapViewState extends State<AmapView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        // gestureRecognizers: gestureRecognizers,
        // onPlatformViewCreated: onPlatformViewCreated,
        creationParams: {},
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
}
