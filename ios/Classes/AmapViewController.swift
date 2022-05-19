//
//  AmapViewController.swift
//  amap_view_muka
//
//  Created by Spice ly on 2022/5/18.
//

import Flutter
import MAMapKit
import AMapFoundationKit
import UIKit

class AmapViewController: NSObject, FlutterPlatformView, MAMapViewDelegate, AmapOptionsSink {
    func setIndoorMap(indoorEnabled: Bool) {
        
    }
    
    
    private var _frame: CGRect
    private var mapView: MAMapView
    private var channel: FlutterMethodChannel
    private var markerController: MarkerController
    private var flutterRegister: FlutterPluginRegistrar
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger register: FlutterPluginRegistrar) {
        flutterRegister = register
        
        // 解决 Failed to bind EAGLDrawable 错误
        // 如果frame是zeroed，则初始化一个宽高
        if (frame.width == 0 || frame.height == 0) {
            _frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        } else {
            _frame = frame
        }
        
        mapView = MAMapView(frame: _frame)
        // 自动调整宽高
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        channel = FlutterMethodChannel(name: "plugins.muka.com/amap_view_muka_marker_\(viewId)", binaryMessenger: register.messenger())
        
        markerController = MarkerController(withChannel: channel, withMap: mapView)
        
        super.init()
        
        channel.setMethodCallHandler(onMethodCall)
        
        
        mapView.delegate = self
        // 处理参数
        if let args = args as? [String: Any] {
            Convert.interpretMapOptions(options: args, delegate: self)
            updateInitialMarkers(options: args["markers"])
        }
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(methodCall.method) {
        case "map#waitForMap":
            result(true)
        case "map#update":
            if let args = methodCall.arguments as? [String: Any] {
                Convert.interpretMapOptions(options: args["options"], delegate: self)
            }
            result(true)
        case "markers#update":
            if let args = methodCall.arguments as? [String: Any] {
                if let markersToAdd = (args["markersToAdd"] as? [Any]) {
                    markerController.addMarkers(markersToAdd: markersToAdd)
                }
                if let markersToChange = args["markersToChange"] as? [Any] {
                    markerController.changeMarkers(markersToChange: markersToChange)
                }
                if let markerIdsToRemove = args["markerIdsToRemove"] as? [Any] {
                    markerController.removeMarkers(markerIdsToRemove: markerIdsToRemove)
                }
            }
            result(true)
        case "camera#update":
            result(true)
        case "setMapType":
            if let args = methodCall.arguments as? [String: Any] {
                setMapType(mapType: args["type"] as! Int)
            }
            result(true)
        case "setMapLanguage":
            if let args = methodCall.arguments as? [String: Any] {
                setMapLanguage(language: args["language"] as! Int)
            }
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func updateInitialMarkers(options: Any?) {
        if let markers = options as? [Any] {
            markerController.addMarkers(markersToAdd: markers)
        }
    }
    
    // MAMapViewDelegate
    
    // 绘制marker
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let ops =  markerController.markerIdToOptions.first(where:{ (arr,val) -> Bool in
                if let v = val as? [String: Any] {
                    if let position = v["position"] as? [String: Double] {
                        if (position["latitude"] == annotation.coordinate.latitude && position["longitude"] == annotation.coordinate.longitude ) {
                            return true
                        }
                        return false
                    }
                }
                return false
            })
            if(ops == nil) {
                return nil
            }
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView?
            
            if let opts = ops?.value as? [String: Any] {
                if let icon = opts["icon"] as? [String: Any] {
                    print(icon)
                    switch icon["type"] as! String {
                    case "marker#asset":
                        annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                        annotationView!.canShowCallout = true
                        annotationView!.animatesDrop = true
                        annotationView!.isDraggable = opts["draggable"] as! Bool
                        
                        
                        let size = icon["size"] as! [String: Int]
                        let img = UIImage(imageLiteralResourceName: flutterRegister.lookupKey(forAsset: icon["url"] as! String))
                        annotationView!.image = img
                        annotationView!.image?.draw(in: CGRect(x:0, y:0, width: CGFloat(size["width"]!), height: CGFloat(size["height"]!)), blendMode: CGBlendMode.screen, alpha: CGFloat(opts["alpha"] as! Double))
                    default:
                        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
                        
                        if annotationView == nil {
                            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                        }
                        print("----------------")
                    }
                } else {
                    annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                    annotationView!.canShowCallout = true
                    annotationView!.animatesDrop = true
                    annotationView!.isDraggable = true
                }
            }
            return annotationView!
        }
        
        return nil
    }
    
    // 地图将要移动时调用
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        print("mapWillMoveByUser ===>", mapView.centerCoordinate)
    }
    
    func mapView(_ mapView: MAMapView!, mapMoveByUser wasUserAction: Bool) {
        print("mapWillMoveByUser ===>", mapView.centerCoordinate)
    }
    
    // 地图移动结束调用
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        let args: [String: Any] = ["latLng": Convert.toJson(location: mapView.centerCoordinate), "zoom": mapView.zoomLevel, "tilt": mapView.cameraDegree, "bearing": mapView.rotationDegree,"duration": 0]
        channel.invokeMethod("map#onMapIdle", arguments: args)
    }
    
    // 单击地图返回经纬度
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        let args: [String: Any] = ["latLng": Convert.toJson(location: coordinate), "zoom": mapView.zoomLevel, "tilt": mapView.cameraDegree, "bearing": mapView.rotationDegree,"duration": 0]
        channel.invokeMethod("map#onMapClick", arguments: args)
    }
    
    // 地图定位失败调用
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        print("didFailToLocateUserWithError ===>", error as Any)
    }
    
    // 点击地图poi时返回信息
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        print("didTouchPois ===>", pois as Any)
    }
    
    // AMapOptionsSink
    func setCameraPosition(camera: CameraPosition) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: camera.target.latitude, longitude:  camera.target.longitude), animated: true)
        mapView.setZoomLevel(CGFloat(camera.zoom), animated: true)
        mapView.setRotationDegree(CGFloat(camera.bearing), animated: true, duration: CFTimeInterval(camera.duration))
        mapView.setCameraDegree(CGFloat(camera.tilt), animated: true, duration: CFTimeInterval(camera.duration))
    }
    
    func setMapType(mapType: Int) {
        switch mapType {
        case 0:
            mapView.mapType = MAMapType.navi
        case 1:
            mapView.mapType = MAMapType.standardNight
        case 3:
            mapView.mapType = MAMapType.satellite
        case 4:
            mapView.mapType = MAMapType.bus
        default:
            mapView.mapType = MAMapType.standard
        }
    }
    func setMapLanguage(language: Int) {
        switch language {
        case 1:
            mapView.mapLanguage = 1
        default:
            mapView.mapLanguage = 0
        }
    }
    
    func setMapZoomLevel(zommLevel: Double) {
        mapView.zoomLevel = zommLevel
    }
    
    func setMapIndoorMap(indoorMap: Bool) {
        mapView.isShowsIndoorMap = indoorMap
    }
    
    func setMapzoomControlsEnabled(zoomControlsEnabled: Bool) {
        mapView.isZoomEnabled = zoomControlsEnabled
    }
    
    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool) {
        mapView.isRotateEnabled = rotateGesturesEnabled
    }
    
    func setScaleEnabled(scaleEnabled: Bool) {
        mapView.showsScale = scaleEnabled
    }
    
    func setCompassEnabled(compassEnabled: Bool) {
        mapView.showsCompass = compassEnabled
    }
    
    func setMyLocationEnabled(myLocationEnabled: Bool) {
        mapView.showsUserLocation = myLocationEnabled
        // 开启用户定位默认开启follow模式
        if myLocationEnabled {
            mapView.userTrackingMode = .follow
        } else {
            mapView.userTrackingMode = .none
        }
    }
    
    func setZoomEnabled(zoomEnabled: Bool) {
        mapView.isZoomEnabled = zoomEnabled
    }
    
    func setScrollEnabled(scrollEnabled: Bool) {
        mapView.isScrollEnabled = scrollEnabled
    }
    
}
