part of amap_view_muka;

/// x、y均为屏幕坐标，屏幕左上角为坐标原点，即(0,0)点。
class AmapPoint {
  final int x;
  final int y;

  AmapPoint(this.x, this.y);

  Map<String, dynamic> toJson() => {
        'x': this.x,
        'y': this.y,
      };

  factory AmapPoint.fromJson(Map<dynamic, dynamic> json) => AmapPoint(json['x'], json['y']);
}
