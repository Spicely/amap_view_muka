part of '../../amap_view_muka.dart';

class AMapCalcRouteResult {
  final List<int>? routeid;

  final int? errorCode;

  final String? errorDetail;

  final String? errorDescription;

  final int? calcRouteType;

  AMapCalcRouteResult({
    this.routeid,
    this.errorCode,
    this.errorDetail,
    this.errorDescription,
    this.calcRouteType,
  });

  factory AMapCalcRouteResult.fromJson(Map<String, dynamic> json) {
    return AMapCalcRouteResult(
      routeid: (json['routeid'] as List?)?.map((e) => int.parse(e.toString())).toList(),
      errorCode: json['errorCode'],
      errorDetail: json['errorDetail'],
      errorDescription: json['errorDescription'],
      calcRouteType: json['calcRouteType'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['routeid'] = routeid;
    data['errorCode'] = errorCode;
    data['errorDetail'] = errorDetail;
    data['errorDescription'] = errorDescription;
    data['calcRouteType'] = calcRouteType;
    return data;
  }
}
