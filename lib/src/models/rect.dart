part of '../../amap_view_muka.dart';

class Rect {
  final int bottom;
  final int left;
  final int right;
  final int top;

  Rect(this.left, this.top, this.right, this.bottom);

  Map<String, int> toJson() {
    return {
      'bottom': bottom,
      'left': left,
      'right': right,
      'top': top,
    };
  }

  @override
  String toString() {
    return 'Rect{bottom: $bottom, left: $left, right: $right, top: $top}';
  }

  Rect copyWith({int? left, int? top, int? right, int? bottom}) => Rect(left ?? this.left, top ?? this.top, right ?? this.right, bottom ?? this.bottom);
}
