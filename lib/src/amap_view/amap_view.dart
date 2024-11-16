part of '../../amap_view_muka.dart';

const _viewType = 'plugins.muka.com/amap_view_muka';

typedef AMapViewOnCreated = void Function(AMapNaviViewController controller);

class AMapView extends StatelessWidget {
  /// 地图初始化完成
  final AMapNaviViewOnCreated? onCreated;

  const AMapView({super.key, this.onCreated});

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    };

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: {},
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
        creationParams: {},
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    }
  }

  void onPlatformViewCreated(int id) async {
    AMapNaviViewController controller = await AMapNaviViewController.init(id);
    // _event = await AMapNaviViewEvent.init(id, (data) {
    //   print('======================');
    //   print(data);
    //   switch (data['type']) {
    //     case 'calculateRouteFailure':
    //       widget.onListen?.onCalculateRouteFailure?.call(data['data']);
    //       break;
    //     case 'onCalculateRouteSuccess':
    //       widget.onListen?.onCalculateRouteSuccess?.call((data['data'] as List<dynamic>).map((e) => AmapNaviPath.fromJson(e)).toList());
    //       break;
    //   }
    // });
    onCreated?.call(controller);
  }
}
