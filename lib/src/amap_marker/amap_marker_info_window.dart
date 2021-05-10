part of amap_view_muka;

abstract class AmapMarkerInfoWindow {
  final Color backgroundColor;

  AmapMarkerInfoWindow({
    this.backgroundColor = Colors.white,
  });

  Map<String, dynamic> toJson() => {};
}
