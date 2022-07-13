part of amap_view_muka;

class AMapImageSize {
  final double height;

  final double width;

  AMapImageSize({
    this.height = 80,
    this.width = 80,
  });

  Map<String, dynamic> toJson() => {
        'height': this.height * window.devicePixelRatio,
        'width': this.width * window.devicePixelRatio,
      };

  factory AMapImageSize.fromJson(Map<dynamic, dynamic> json) => AMapImageSize(
        height: json['height'],
        width: json['width'],
      );
}

abstract class AMapImage {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 80 * 80
  final AMapImageSize? size;

  String get type => '';

  AMapImage(
    this.url, {
    this.size,
  });

  Map<String, dynamic> toJson() => {};
}

class AMapViewAssetImage implements AMapImage {
  /// 地址
  final String url;

  final String? package;

  /// 图片尺寸
  ///
  /// 默认 80 * 80
  final AMapImageSize? size;

  AMapViewAssetImage(
    this.url, {
    this.package,
    this.size,
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
        'package': this.package,
        'size': this.size == null ? AMapImageSize().toJson() : this.size!.toJson(),
      };

  factory AMapViewAssetImage.fromJson(Map<dynamic, dynamic> json) => AMapViewAssetImage(
        json['url'],
        package: json['package'],
        size: json['size'] != null ? AMapImageSize.fromJson(json['size']) : null,
      );
}

class AMapWebImage implements AMapImage {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 80 * 80
  final AMapImageSize? size;

  AMapWebImage(
    this.url, {
    this.size,
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
        'size': this.size == null ? AMapImageSize().toJson() : this.size!.toJson(),
      };

  factory AMapWebImage.fromJson(Map<dynamic, dynamic> json) => AMapWebImage(json['url']);
}

class AMapViewImage {
  /// 从assets读取
  static AMapImage asset(
    String url, {
    String? package,
    AMapImageSize? size,
  }) {
    return AMapViewAssetImage(
      url,
      package: package,
      size: size,
    );
  }

  // /// 从互联网中读取
  // static AMapImage web(String url) {
  //   return AMapMarkerWebIcon(url);
  // }
}
