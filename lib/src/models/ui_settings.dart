// ignore_for_file: constant_identifier_names

part of '../../amap_view_muka.dart';

class UiSettings {
  static const int ZOOM_POSITION_RIGHT_CENTER = 1;

  static const int ZOOM_POSITION_RIGHT_BUTTOM = 2;

  final int zoomPosition;

  const UiSettings({
    this.zoomPosition = ZOOM_POSITION_RIGHT_BUTTOM,
  });

  UiSettings copyWith({int? zoomPosition}) {
    return UiSettings(
      zoomPosition: zoomPosition ?? this.zoomPosition,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoomPosition': zoomPosition,
    };
  }
}
