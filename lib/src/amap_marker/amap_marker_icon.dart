part of amap_view_muka;

abstract class AmapMarkerIcon {
  /// 地址
  final String url;

  String get type => '';

  AmapMarkerIcon(this.url);

  Map<String, dynamic> toJson() => {};
}

class AmapMarkerAssetIcon implements AmapMarkerIcon {
  /// 地址
  final String url;

  final String name;

  final double scale;

  AmapMarkerAssetIcon(this.url, this.name, this.scale);

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

  AmapMarkerWebIcon(this.url);

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
