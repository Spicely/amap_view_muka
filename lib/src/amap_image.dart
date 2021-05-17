part of amap_view_muka;

class AmapImageSize {
  final double height;

  final double width;

  const AmapImageSize({
    this.height = 80,
    this.width = 80,
  });
}

abstract class AmapImage {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  final AmapImageSize size;

  String get type => '';

  AmapImage(
    this.url, {
    this.size = const AmapImageSize(),
  });

  Map<String, dynamic> toJson() => {};
}

class AmapViewAssetImage implements AmapImage {
  /// 地址
  final String url;

  final String name;

  final double scale;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  final AmapImageSize size;

  AmapViewAssetImage(
    this.url,
    this.name,
    this.scale, {
    this.size = const AmapImageSize(),
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
        'name': this.name,
        'scale': this.scale,
      };

  factory AmapViewAssetImage.fromJson(Map<dynamic, dynamic> json) => AmapViewAssetImage(json['url'], json['name'], json['scale']);
}

class AmapWebImage implements AmapImage {
  /// 地址
  final String url;

  /// 图片尺寸
  ///
  /// 默认 50 * 50
  final AmapImageSize size;

  AmapWebImage(
    this.url, {
    this.size = const AmapImageSize(),
  });

  /// marker图标类型
  String get type => 'marker#asset';

  Map<String, dynamic> toJson() => {
        'url': this.url,
        'type': this.type,
      };

  factory AmapWebImage.fromJson(Map<dynamic, dynamic> json) => AmapWebImage(json['url']);
}

class AmapViewImage {
  /// 从assets读取
  static Future<AmapImage> asset(BuildContext context, String url, {AssetBundle? bundle, String? package}) async {
    final AssetImage assetImage = AssetImage(url, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey = await assetImage.obtainKey(createLocalImageConfiguration(context));
    return AmapViewAssetImage(url, assetBundleImageKey.name, assetBundleImageKey.scale);
  }

  // /// 从互联网中读取
  // static AmapImage web(String url) {
  //   return AmapMarkerWebIcon(url);
  // }
}
