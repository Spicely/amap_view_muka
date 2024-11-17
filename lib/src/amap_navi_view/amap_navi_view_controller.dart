part of '../../amap_view_muka.dart';

const _naviTag = 'plugins.muka.com/amap_navi_view_muka_controller';

class AMapNaviViewController {
  late MethodChannel channel;

  AMapNaviViewController._(this.channel) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AMapNaviViewController> init(int id) async {
    MethodChannel methodChannel = MethodChannel('${_naviTag}_$id');
    return AMapNaviViewController._(methodChannel);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'marker#onTap':
        break;

      default:
        throw MissingPluginException();
    }
  }

  Future<void> setViewOptions(AMapNaviViewOptions options) async {
    await channel.invokeMethod('setAMapNaviViewOptions', options.toJson());
    return;
  }

  Future<void> setAMap(AMap aMap) async {
    await channel.invokeMethod('setAMap', aMap.toJson());
    return;
  }
}
