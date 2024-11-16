part of '../../amap_view_muka.dart';

class AmapNaviParams {
  final AMapNaviViewOptions? viewOptions;

  final AMap aMap;

  const AmapNaviParams({
    this.viewOptions,
    this.aMap = const AMap(),
  });

  Map<String, dynamic> toJson() => {
        'viewOptions': viewOptions?.toJson(),
        'aMap': aMap.toJson(),
      };
}
