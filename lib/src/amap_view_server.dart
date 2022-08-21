part of amap_view_muka;

class AMapViewServer {
  static MethodChannel _channel = MethodChannel('plugins.muka.com/amap_view_muka_server');

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
}
