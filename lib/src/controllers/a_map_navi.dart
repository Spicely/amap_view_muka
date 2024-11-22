part of '../../amap_view_muka.dart';

class AMapNavi {
  final MethodChannel _channel;

  AMapNavi(this._channel);

  Future<dynamic> get naviPaths async {
    final res = await _channel.invokeMapMethod<int, dynamic>(AMapNaviMethod.getNaviPaths);
    return res;
  }
}
