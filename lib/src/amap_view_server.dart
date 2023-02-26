part of amap_view_muka;

/// 仅Android可用
enum AMapLocationMode {
  /// 高精度模式
  HIGHT_ACCURACY,

  /// 低功耗模式
  BATTERY_SAVING,

  /// 仅设备模式,不支持室内环境的定位
  DEVICE_SENSORS,
}

/// 仅IOS可用
enum AMapLocationAccuracy {
  /// 最快 精确度最底 约秒到
  THREE_KILOMETERS,

  /// 精确度较低 约秒到
  KILOMETER,

  /// 精确度较低 约2s
  HUNDREE_METERS,

  /// 精确度较高 约5s
  NEAREST_TENMETERS,

  /// 最慢 精确度最高 约8s
  BEST,
}

class AMapViewServer {
  static MethodChannel _channel = MethodChannel('plugins.muka.com/amap_navi_view_muka_server');

  /// 设置Android和iOS的apikey，建议在weigdet初始化时设置<br>
  /// apiKey的申请请参考高德开放平台官网<br>
  /// Android端: https://lbs.amap.com/api/android-location-sdk/guide/create-project/get-key<br>
  /// iOS端: https://lbs.amap.com/api/ios-location-sdk/guide/create-project/get-key<br>
  /// [androidKey] Android平台的key<br>
  /// [iosKey] ios平台的key<br>
  static Future<void> setApiKey(String androidKey, String iosKey) async {
    await _channel.invokeMethod<bool>('setApiKey', {'android': androidKey, 'ios': iosKey});
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyShow(bool hasContains, bool hasShow) async {
    await _channel.invokeMethod('updatePrivacyShow', {
      'hasContains': hasContains,
      'hasShow': hasShow,
    });
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await _channel.invokeMethod('updatePrivacyAgree', {
      'hasAgree': hasAgree,
    });
  }

  /// 单次定位
  ///
  /// androidMode 定位方式 [ 仅适用android ]
  ///
  /// iosAccuracy 精确度 [ 仅适用ios ]
  static Future<Location> fetch({
    AMapLocationMode androidMode = AMapLocationMode.HIGHT_ACCURACY,
    AMapLocationAccuracy iosAccuracy = AMapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    dynamic location = await _channel.invokeMethod('fetch', {
      'mode': androidMode.index,
      'accuracy': iosAccuracy.index,
    });
    return Location.fromJson(location);
  }
}
