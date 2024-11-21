part of '../../amap_view_muka.dart';

const _naviViewType = 'plugins.muka.com/amap_navi_view_muka';

typedef AMapNaviViewOnCreated = void Function(AMapNaviViewController controller);

class AmapNaviPath {
  final int allTime;

  final int allLength;

  final int allCameras;

  AmapNaviPath(this.allTime, this.allLength, this.allCameras);

  factory AmapNaviPath.fromJson(Map<String, dynamic> json) => AmapNaviPath(
        json['allTime'] as int,
        json['allLength'] as int,
        json['allCameras'] as int,
      );
}

class AmapNaviEventCallback {
  /// 路径规划成功
  final Function(List<AmapNaviPath> data)? onCalculateRouteSuccess;

  /// 路径规划失败
  final Function(dynamic data)? onCalculateRouteFailure;

  AmapNaviEventCallback({
    this.onCalculateRouteFailure,
    this.onCalculateRouteSuccess,
  });
}

/// 路线规划机车类型
enum AmapNaviCalculateType {
  /// 驾车/货车
  drive,

  /// 骑行
  ride,

  /// 步行
  walk,

  /// 摩托车
  cycle,

  /// 电动车
  electric
}

// class AmapNaviLocationInfo {
//   /// 位置信息
//   final String address;

//   final LatLng? latLng;

//   AmapNaviLocationInfo({
//     required this.address,
//     this.latLng,
//   });

//   Map<String, dynamic> toJson() => {'address': address, 'latLng': latLng?.toJson()};
// }

// class AmapNaviStartToEnd {
//   /// 开始位置
//   final AmapNaviLocationInfo start;

//   /// 结束位置
//   final AmapNaviLocationInfo end;

//   /// 途径位置
//   final List<AmapNaviLocationInfo>? waysPoiIds;

//   AmapNaviStartToEnd({
//     required this.start,
//     required this.end,
//     this.waysPoiIds,
//   });

//   Map<String, dynamic> toJson() => {'start': start.toJson(), 'end': end.toJson(), 'waysPoiIds': waysPoiIds?.map((e) => e.toJson())};
// }

class AMapNaviView extends StatelessWidget {
  final AmapNaviParams initParams;

  final AMapNaviViewController? controller;

  const AMapNaviView({
    super.key,
    this.initParams = const AmapNaviParams(),
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>{
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    };

    if (Platform.isAndroid) {
      return AndroidView(
        viewType: _naviViewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: initParams.toJson(),
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: TextDirection.ltr,
        // layoutDirection: widget.layoutDirection,
        hitTestBehavior: PlatformViewHitTestBehavior.opaque,
      );
    } else {
      return UiKitView(
        viewType: _naviViewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: initParams.toJson(),
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    }
  }

  void onPlatformViewCreated(int id) async {
    controller?._init(id);
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
    // controller?.call(controller);
  }
}
