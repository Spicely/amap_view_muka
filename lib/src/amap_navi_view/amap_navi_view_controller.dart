part of amap_view_muka;

const _naviTag = 'plugins.muka.com/amap_view_muka_controller';

class AMapNaviViewController {
  late MethodChannel _channel;

  late _AMapNaviViewState _mapState;

  AMapNaviViewController._(this._channel, this._mapState) {
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AMapNaviViewController> init(int id, _AMapNaviViewState state) async {
    MethodChannel channel = MethodChannel('${_naviTag}_$id');
    return AMapNaviViewController._(channel, state);
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'marker#onTap':
        break;

      default:
        throw MissingPluginException();
    }
  }
}
