part of '../../amap_view_muka.dart';

const _naviEventTag = 'plugins.muka.com/amap_view_muka_event';

typedef AMapNaviViewEventCallBack = void Function(dynamic data);

class AMapNaviViewEvent {
  late final EventChannel _channel;

  late final AMapNaviViewEventCallBack _callBack;

  AMapNaviViewEvent._(this._channel, this._callBack) {
    _channel.receiveBroadcastStream().listen(_callBack);
  }

  static Future<AMapNaviViewEvent> init(int id, AMapNaviViewEventCallBack callBack) async {
    EventChannel channel = EventChannel('${_naviEventTag}_$id');
    return AMapNaviViewEvent._(channel, callBack);
  }
}
