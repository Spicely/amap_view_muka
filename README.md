# amap_view_muka

Flutter高德地图插件

## 引入方式

```
    amap_view_muka: ^0.1.0
```

<!-- ## Web
```
    /// 在html文件中加入
    <script type="text/javascript" src="https://webapi.amap.com/maps?v=1.4.15&key=你的key"></script>
``` -->

## 支持
 -  显示地图
    - [x] 显示定位蓝点
    - [x] 显示室内地图
    - [x] 切换地图图层
    - [x] 使用离线地图 [目前只支持官方UI]
    - [x] 显示英文地图
    - [ ] 自定义地图

## Android

在`AndroidManifest.xml`添加如下代码
`
 <meta-data android:name="com.amap.api.v2.apikey" android:value="你的key" />
`

## IOS

在`Info.plist`添加如下代码

```
    // 默认
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>App需要您的同意,才能访问位置</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>App需要您的同意,才能访问位置</string>
    <key>amap_key</key>
    <string>你的key</string>

    // 导航 [后台持续定位只需要location]
    <key>UIBackgroundModes</key> 
    <array> 
        <string>location</string>
        <string>audio</string> 
    </array>
```

