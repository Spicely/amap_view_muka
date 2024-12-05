// ignore_for_file: constant_identifier_names

part of '../amap_view_muka.dart';

// /// 仅Android可用
// enum AMapLocationMode {
//   /// 高精度模式
//   HIGHT_ACCURACY,

//   /// 低功耗模式
//   BATTERY_SAVING,

//   /// 仅设备模式,不支持室内环境的定位
//   DEVICE_SENSORS,
// }

// /// 仅IOS可用
// enum AMapLocationAccuracy {
//   /// 最快 精确度最底 约秒到
//   THREE_KILOMETERS,

//   /// 精确度较低 约秒到
//   KILOMETER,

//   /// 精确度较低 约2s
//   HUNDREE_METERS,

//   /// 精确度较高 约5s
//   NEAREST_TENMETERS,

//   /// 最慢 精确度最高 约8s
//   BEST,
// }

class AMapViewServer {
  static const MethodChannel _channel = MethodChannel('plugins.muka.com/amap_view_muka_server');

  /// 设置Android和iOS的apiKey，建议在widget初始化时设置<br>
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
    await _channel.invokeMethod('updatePrivacyShow', {'hasContains': hasContains, 'hasShow': hasShow});
  }

  /// 确保调用SDK任何接口前先调用更新隐私合规updatePrivacyShow、updatePrivacyAgree两个接口并且参数值都为true，若未正确设置有崩溃风险
  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    await _channel.invokeMethod('updatePrivacyAgree', {'hasAgree': hasAgree});
  }

  /// 关键字搜索poi
  ///
  /// [keyword] 关键字
  ///
  /// [types] 类型，多个类型用“|”分割 可选值:文本分类、分类代码
  ///
  /// [city] 城市名称
  ///
  /// [pageSize] 每页记录数, 范围1-25, [default = 20]
  ///
  /// [page] 当前页数, 范围1-100, [default = 1]
  ///
  /// [cityLimit] 强制城市限制功能 [default = true]，例如：在上海搜索天安门，如果cityLimit为false，将不返回北京的天安门相关的POI
  static Future<PoiResult> searchKeyword(
    String keyword, {
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    bool cityLimit = true,
    LatLonPoint? latLng,
    bool isDistanceSort = true,
  }) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    String? res = await _channel.invokeMethod<String>('searchKeyword', {
      'keyword': keyword,
      'city': city,
      'types': types,
      'pageSize': pageSize,
      'page': page,
      'cityLimit': cityLimit,
      'location': latLng?.toJson(),
      'isDistanceSort': isDistanceSort,
    });

    return PoiResult.fromJson(json.decode(res!));
  }

  /// 周边搜索poi
  ///
  /// [center] 中心点
  ///
  /// [keyword] 查询关键字，多个关键字用“|”分割
  ///
  /// [radius] 查询半径，范围：0-50000，单位：米 [default = 1500]
  ///
  /// [types] 类型，多个类型用“|”分割 可选值:文本分类、分类代码
  ///
  /// [city] 城市名称
  ///
  /// [pageSize] 每页记录数, 范围1-25, [default = 20]
  ///
  /// [page] 当前页数, 范围1-100, [default = 1]
  static Future<PoiResult> searchAround(
    LatLonPoint center, {
    String keyword = '',
    String city = '',
    String types = '',
    int pageSize = 20,
    int page = 1,
    int radius = 1500,
  }) async {
    assert(page >= 1 && page <= 100, 'page must be between 1 and 100');
    assert(pageSize >= 1 && pageSize <= 25, 'pageSize must be between 1 and 25');
    assert(radius >= 0 && radius <= 50000, 'radius must be between 0 and 50000');
    String? res = await _channel.invokeMethod<String>('searchAround', {
      'keyword': keyword,
      'city': city,
      'types': types,
      'pageSize': pageSize,
      'page': page,
      'longitude': center.longitude,
      'latitude': center.latitude,
      'radius': radius,
    });
    return PoiResult.fromJson(json.decode(res!));
  }

  /// 输入内容自动提示
  ///
  /// [keyword] 关键字
  ///
  /// [city] 城市名称
  ///
  /// [latLng] 如果设置，在此location附近优先返回搜索关键词信息
  ///
  /// [cityLimit] 强制城市限制功能 [default = false]，例如：在上海搜索天安门，如果cityLimit为true，将不返回北京的天安门相关的POI
  static Future<List<AMapTip>> fetchInputTips(String keyword, {String city = '', LatLonPoint? latLng, bool cityLimit = false}) async {
    final List? dataList = await _channel.invokeMethod('fetchInputTips', {
      'keyword': keyword,
      'city': city,
      'latitude': latLng?.latitude,
      'longitude': latLng?.longitude,
      'cityLimit': cityLimit,
    });
    return dataList?.map((e) => AMapTip.fromJson(e)).toList() ?? [];
  }

  /// 单次定位
  ///
  /// androidMode 定位方式 [ 仅适用android ]
  ///
  /// iosAccuracy 精确度 [ 仅适用ios ]
  static Future<AMapLocation> fetch({
    AMapLocationMode androidMode = AMapLocationMode.hight_accuracy,
    AMapLocationAccuracy iosAccuracy = AMapLocationAccuracy.three_kilometers,
  }) async {
    dynamic location = await _channel.invokeMapMethod<String, dynamic>('fetch', {
      'mode': androidMode.index,
      'accuracy': iosAccuracy.index,
    });
    return AMapLocation.fromJson(location);
  }

  /// 计算距离
  static Future<double> calculateDistance(List<LatLonPoint> start, LatLonPoint end, [int type = DistanceSearch.TYPE_DRIVING_DISTANCE]) async {
    return await _channel.invokeMethod(
      'calculateDistance',
      {'start': start.map((e) => e.toJson()).toList(), 'end': end.toJson(), 'type': type},
    );
  }
}

abstract class DistanceSearch {
  static const int TYPE_DISTANCE = 0;

  static const int TYPE_DRIVING_DISTANCE = 1;

  static const int TYPE_WALK_DISTANCE = 3;
}
