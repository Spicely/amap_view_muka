part of amap_view_muka;

class AmapMarkerIconSize {
  final double height;

  final double width;

  const AmapMarkerIconSize({
    this.height = 50,
    this.width = 50,
  });
}

abstract class AmapMarkerIcon {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  AmapMarkerIconSize size;

  String get type => '';

  AmapMarkerIcon(
    this.url, {
    this.size = const AmapMarkerIconSize(),
  });

  Map<String, dynamic> toJson() => {};
}

class AmapMarkerAssetIcon implements AmapMarkerIcon {
  /// 地址
  final String url;

  final String name;

  final double scale;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  AmapMarkerIconSize size;

  AmapMarkerAssetIcon(
    this.url,
    this.name,
    this.scale, {
    this.size = const AmapMarkerIconSize(),
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
        'name': this.name,
        'scale': this.scale,
      };

  factory AmapMarkerAssetIcon.fromJson(Map<dynamic, dynamic> json) => AmapMarkerAssetIcon(json['url'], json['name'], json['scale']);
}

class AmapMarkerWebIcon implements AmapMarkerIcon {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  AmapMarkerIconSize size;

  AmapMarkerWebIcon(
    this.url, {
    this.size = const AmapMarkerIconSize(),
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
      };

  factory AmapMarkerWebIcon.fromJson(Map<dynamic, dynamic> json) => AmapMarkerWebIcon(json['url']);
}

class AmapMarkerImage {
  /// 从assets读取
  static Future<AmapMarkerIcon> asset(BuildContext context, String url, {AssetBundle? bundle, String? package}) async {
    final AssetImage assetImage = AssetImage(url, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey = await assetImage.obtainKey(createLocalImageConfiguration(context));
    return AmapMarkerAssetIcon(url, assetBundleImageKey.name, assetBundleImageKey.scale);
  }

  /// 从互联网中读取
  static AmapMarkerIcon web(String url) {
    return AmapMarkerWebIcon(url);
  }
}
