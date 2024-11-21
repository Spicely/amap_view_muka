part of '../../amap_view_muka.dart';

const _naviTag = 'plugins.muka.com/amap_navi_view_muka_controller';

class AMapNaviViewController {
  late MethodChannel channel;

  final ObserverList<AMapNaviListener> _aMapNaviListeners = ObserverList<AMapNaviListener>();

  List<AMapNaviListener> get aMapNaviListeners {
    final List<AMapNaviListener> listeners = List<AMapNaviListener>.from(_aMapNaviListeners);
    return listeners;
  }

  bool get hasListeners {
    return _aMapNaviListeners.isNotEmpty;
  }

  void _init(int id) async {
    channel = MethodChannel('${_naviTag}_$id');
    channel.setMethodCallHandler(_handleMethodCall);
  }

  void addAMapNaviListener(AMapNaviListener listener) {
    _aMapNaviListeners.add(listener);
  }

  void removeAMapNaviListener(AMapNaviListener listener) {
    _aMapNaviListeners.remove(listener);
  }

  void _onAMapNaviEvent(Function(AMapNaviListener) callback) {
    for (AMapNaviListener listener in _aMapNaviListeners) {
      if (!_aMapNaviListeners.contains(listener)) {
        return;
      }
      callback(listener);
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    try {
      switch (call.method) {
        case 'marker#onTap':
          break;
        case ListenerMethod.onInitNaviFailure:
          _onAMapNaviEvent((listener) => listener.onInitNaviFailure());
          break;
        case ListenerMethod.onInitNaviSuccess:
          _onAMapNaviEvent((listener) => listener.onInitNaviSuccess());
          break;
        case ListenerMethod.onStartNavi:
          _onAMapNaviEvent((listener) => listener.onStartNavi(call.arguments));
          break;
        case ListenerMethod.onTrafficStatusUpdate:
          _onAMapNaviEvent((listener) => listener.onTrafficStatusUpdate());
          break;
        case ListenerMethod.onLocationChange:
          _onAMapNaviEvent((listener) => listener.onLocationChange(AMapNaviLocation.fromJson(jsonDecode(call.arguments))));
          break;
        case ListenerMethod.onGetNavigationText:
          final args = (call.arguments as Map).cast<String, dynamic>();
          _onAMapNaviEvent((listener) => listener.onGetNavigationText(args['type'], args['text']));
          break;
        case ListenerMethod.onEndEmulatorNavi:
          _onAMapNaviEvent((listener) => listener.onEndEmulatorNavi());
          break;
        case ListenerMethod.onArriveDestination:
          _onAMapNaviEvent((listener) => listener.onArriveDestination());
          break;
        case ListenerMethod.onReCalculateRouteForYaw:
          _onAMapNaviEvent((listener) => listener.onReCalculateRouteForYaw());
          break;
        case ListenerMethod.onReCalculateRouteForTrafficJam:
          _onAMapNaviEvent((listener) => listener.onReCalculateRouteForTrafficJam());
          break;
        case ListenerMethod.onArrivedWayPoint:
          _onAMapNaviEvent((listener) => listener.onArrivedWayPoint(call.arguments));
          break;
        case ListenerMethod.onGpsOpenStatus:
          _onAMapNaviEvent((listener) => listener.onGpsOpenStatus(call.arguments));
          break;
        case ListenerMethod.onNaviInfoUpdate:
          // _onAMapNaviEvent((listener) => listener.onNaviInfoUpdate(NaviInfo.fromJson(jsonDecode(call.arguments))));
          break;
        case ListenerMethod.onCalculateRouteSuccess:
          print(21321321);
          final args = (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
          print(21321321);
          _onAMapNaviEvent((listener) => listener.onCalculateRouteSuccess(AMapCalcRouteResult.fromJson(args)));
          break;
        case ListenerMethod.onCalculateRouteFailure:
          print(21321321);
          final args = (call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>();
          print(21321321);
          _onAMapNaviEvent((listener) => listener.onCalculateRouteFailure(AMapCalcRouteResult.fromJson(args)));
          break;

        default:
          throw MissingPluginException();
      }
    } catch (e) {
      debugPrint(e.toString());
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

  /// 驾车路径规划计算
  ///
  /// [start] 起点坐标
  ///
  /// [end] 终点坐标
  ///
  /// [way] 途径点坐标
  ///
  /// [strategy] 策略 可调用strategyConvert方法进行策略转换
  Future<void> calculateDriveRoute(List<LatLonPoint> start, List<LatLonPoint> way, List<LatLonPoint> end, int strategy) async {
    await channel.invokeMethod('calculateDriveRoute', {
      'start': start.map((e) => e.toJson()).toList(),
      'way': way.map((e) => e.toJson()).toList(),
      'end': end.map((e) => e.toJson()).toList(),
      'strategy': strategy,
    });
  }

  /// 进行算路策略转换，将传入的特定规则转换成PathPlanningStrategy的枚举值。
  ///
  /// 注意：该接口仅驾车模式有效
  ///
  /// [avoidCongestion] 是否避开拥堵
  ///
  /// [avoidHighway] 是否避开高速
  ///
  /// [avoidCost] 是否避免收费
  ///
  /// [prioritiseHighway] 是否优先高速
  ///
  /// [multipleRoute] 是否多路径规划
  Future<int> strategyConvert(bool avoidCongestion, bool avoidHighway, bool avoidCost, bool prioritiseHighway, bool multipleRoute) async {
    return await channel.invokeMethod('strategyConvert', {
      'avoidCongestion': avoidCongestion,
      'avoidHighway': avoidHighway,
      'avoidCost': avoidCost,
      'prioritiseHighway': prioritiseHighway,
      'multipleRoute': multipleRoute,
    });
  }
}
