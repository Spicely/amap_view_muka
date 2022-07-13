part of amap_view_muka;

/// x、y均为屏幕坐标，屏幕左上角为坐标原点，即(0,0)点。
class AMapPoint {
  final int x;
  final int y;

  AMapPoint(this.x, this.y);

  Map<String, dynamic> toJson() => {
        'x': this.x,
        'y': this.y,
      };

  factory AMapPoint.fromJson(Map<dynamic, dynamic> json) => AMapPoint(json['x'], json['y']);
}
