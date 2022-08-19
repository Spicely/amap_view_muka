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

  final Uint8List? data;

  String get type => '';

  AMapImage(
    this.url, {
    this.size,
    this.data,
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

  final Uint8List? data;

  AMapViewAssetImage(
    this.url, {
    this.package,
    this.size,
    this.data,
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

  final Uint8List? data;

  AMapWebImage(
    this.url, {
    this.size,
    this.data,
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

class AMapUint8ListImage implements AMapImage {
  final String url;

  /// 地址
  final Uint8List data;

  /// 图片尺寸
  ///
  /// 默认 80 * 80
  final AMapImageSize? size;

  AMapUint8ListImage(
    this.url, {
    this.size,
    required this.data,
  });

  /// marker图标类型
  String get type => 'marker#byteArray';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
        'size': this.size == null ? AMapImageSize().toJson() : this.size!.toJson(),
        'data': this.data.buffer.asUint8List(),
      };

  factory AMapUint8ListImage.fromJson(Map<dynamic, dynamic> json) => AMapUint8ListImage(json['url'], data: json['data']);
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

  static AMapImage uint8List(
    Uint8List data, {
    AMapImageSize? size,
  }) {
    return AMapUint8ListImage(
      '',
      data: data,
      size: size,
    );
  }

  // /// 从互联网中读取
  // static AMapImage web(String url) {
  //   return AMapMarkerWebIcon(url);
  // }
}
