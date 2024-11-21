part of '../../amap_view_muka.dart';

class AMapCalcRouteResult {
  final List<int>? routeid;

  final int? errorCode;

  AMapCalcRouteResult({
    this.routeid,
    this.errorCode,
  });

  factory AMapCalcRouteResult.fromJson(Map<String, dynamic> json) {
    return AMapCalcRouteResult(
      routeid: json['routeid'],
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routeid'] = routeid;
    data['errorCode'] = errorCode;
    return data;
  }
}
