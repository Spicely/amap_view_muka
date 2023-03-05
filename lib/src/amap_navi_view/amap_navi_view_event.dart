part of amap_view_muka;

const _naviEventTag = 'plugins.muka.com/amap_view_muka_event';

typedef void AMapNaviViewEventCallBack(dynamic data);

class AMapNaviViewEvent {
  late EventChannel _channel;

  late AMapNaviViewEventCallBack _callBack;

  AMapNaviViewEvent._(this._channel, this._callBack) {
    _channel.receiveBroadcastStream()..listen(_callBack);
  }

  static Future<AMapNaviViewEvent> init(int id, AMapNaviViewEventCallBack callBack) async {
    EventChannel channel = EventChannel('${_naviEventTag}_$id');
    return AMapNaviViewEvent._(channel, callBack);
  }
}
