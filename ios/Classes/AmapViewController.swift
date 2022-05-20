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
        case "marker#add":
            if let args = methodCall.arguments as? [String: Any] {
                markerController.addMarker(options: args)
            }
            result(true)
        case "marker#update":
            if let args = methodCall.arguments as? [String: Any] {
                markerController.updateMarker(options: args)
            }
            result(true)
        case "marker#delete":
//            if let args = methodCall.arguments as? [String: Any] {
//                markerController.updateMarker(options: args)
//            }
            result(true)
        case "enabledMyLocation":
            if let args = methodCall.arguments as? [String: Any] {
                setMyLocationStyle(myLocationStyle: args)
            }
            result(true)
        case "disbleMyLocation":
            mapView.showsUserLocation = false
            mapView.userTrackingMode = .none
            result(true)
        case "setZoomLevel":
            if let args = methodCall.arguments as? [String: Any] {
                setMapZoomLevel(zommLevel: args["level"] as! Double)
            }
            result(true)
        case "setIndoorMap":
            if let args = methodCall.arguments as? [String: Any] {
                setIndoorMap(indoorEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setCameraPosition":
            if let args = methodCall.arguments as? [String: Any] {
                setCameraPosition(camera: Convert.toCameraPosition(opts: args))
            }
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
        case "setZoomControlsEnabled":
            result(true)
        case "setCompassEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                setCompassEnabled(compassEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setLogoPosition":
            if let args = methodCall.arguments as? [String: Any] {
                setLogoPosition(logoPosition: args["position"] as! Int)
            }
            result(true)
        case "setMyLocationButtonEnabled":
            result(true)
        case "setZoomGesturesEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                zoomGesturesEnabled(zoomGesturesEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setScrollGesturesEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                scrollGesturesEnabled(scrollGesturesEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setRotateGesturesEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                rotateGesturesEnabled(rotateGesturesEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setTiltGesturesEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                tiltGesturesEnabled(tiltGesturesEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "setAllGesturesEnabled":
            if let args = methodCall.arguments as? [String: Any] {
                allGesturesEnabled(allGesturesEnabled: args["enabled"] as! Bool)
            }
            result(true)
        case "getZoomGesturesEnabled":
            result(mapView.isZoomEnabled)
        case "getScrollGesturesEnabled":
            result(mapView.isScrollEnabled)
        case "getRotateGesturesEnabled":
            result(mapView.isRotateEnabled)
        case "getTiltGesturesEnabled":
            result(mapView.isRotateCameraEnabled)
        case "setGestureScaleByMapCenter":
            result(true)
        case "animateCamera":
            if let args = methodCall.arguments as? [String: Any] {
                setCameraPosition(camera: Convert.toCameraPosition(opts: args["cameraPosition"] as! [String : Any]))
            }
            result(true)
        case "setMapStatusLimits":
            if let args = methodCall.arguments as? [String: Any] {
                setMapStatusLimits(opts: args)
            }
            result(true)
        case "getMapScreenShot":
            if let args = methodCall.arguments as? [String: Any] {
                let opts = args["shot"] as! [String: Any]
                mapView.takeSnapshot(in: CGRect(x: opts["x"] as! Double, y: opts["y"] as! Double, width: opts["width"] as! Double, height: opts["height"] as! Double)) { img,_  in
                    if img != nil {
                        let compressImage = img!.jpegData(compressionQuality: opts["compressionQuality"] as! Double)
                        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).map(\.path)
                        let filePath = URL(fileURLWithPath: paths[0]).appendingPathComponent("shot_amap.png")
                        do {
                            try compressImage!.write(to: filePath)
                            result(filePath.path)
                        } catch {
                            result(nil)
                        }
                    }
                    result(nil)
                }
            }
        case "setPointToCenter":
            result(true)
           
           
//        case "map#update":
//            if let args = methodCall.arguments as? [String: Any] {
//                Convert.interpretMapOptions(options: args["options"], delegate: self)
//            }
//            result(true)
//
//        case "camera#update":
//            result(true)
       
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
        if annotation is MAPointAnnotation {
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
                    switch icon["type"] as! String {
                    case "marker#asset":
                        annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                        annotationView!.canShowCallout = true
                        annotationView!.animatesDrop = true
                        annotationView!.isDraggable = opts["draggable"] as! Bool
                        
                        
                        let size = icon["size"] as! [String: Double]
                        let img = UIImage(imageLiteralResourceName: flutterRegister.lookupKey(forAsset: icon["url"] as! String))
                        if let newImg = resizeImage(image: img, targetSize: CGSize(width: size["width"]!, height: size["height"]!), alpha: CGFloat(opts["alpha"] as! Double)) {
                            annotationView!.image = newImg
                        }
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
    
    func setMapStatusLimits(opts: [String: Any]) {
        let southwestLatLng = opts["southwestLatLng"] as! [String: Double]
        let northeastLatLng = opts["southwestLatLng"] as! [String: Double]
        let boundary = MACoordinateRegion.init(center: Convert.toCLLocationCoordinate2D(options: southwestLatLng), span: Convert.toMACoordinateSpan(options: northeastLatLng))
        mapView.limitRegion = boundary
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
    
    func setLogoPosition(logoPosition: Int) {
        switch logoPosition {
        case 1:
            mapView.logoCenter = CGPoint(x: 0, y: _frame.height - 40)
        case 2:
            mapView.logoCenter = CGPoint(x: 40, y: _frame.height - 40)
        case 3:
            mapView.logoCenter = CGPoint(x: _frame.width / 2, y: _frame.height - 40)
        case 4:
            mapView.logoCenter = CGPoint(x: _frame.width - 40, y: _frame.height - 40)
        default:
            mapView.logoCenter = CGPoint(x: 40, y: _frame.height - 40)
        }
    }
    
    func setMyLocationStyle(myLocationStyle: [String: Any]) {
        let enabled = myLocationStyle["enabled"] as! Bool
        mapView.showsUserLocation = enabled
        // 开启用户定位默认开启follow模式
        if enabled {
            mapView.userTrackingMode = .follow
        } else {
            mapView.userTrackingMode = .none
        }
//        let r = MAUserLocationRepresentation()
//        r.showsHeadingIndicator = true
//        r.showsAccuracyRing = true
//        if let icon = myLocationStyle["icon"] as? [String: Any] {
//            let size = icon["size"] as! [String: Int]
//            let img = UIImage(imageLiteralResourceName: flutterRegister.lookupKey(forAsset: icon["url"] as! String))
//            if let newImg = resizeImage(image: img, targetSize: CGSize(width: CGFloat(size["width"]!), height: CGFloat(size["height"]!)), alpha: CGFloat(1.0)) {
//                r.image = newImg
//            }
//        }
//        if let strokeColor = myLocationStyle["strokeColor"] as? [Int] {
//            r.strokeColor = UIColor(red: CGFloat(strokeColor[0]/255), green: CGFloat(strokeColor[1]/255), blue: CGFloat(strokeColor[2]/255), alpha: 1.0)
//        }
//        if let strokeWidth = myLocationStyle["strokeWidth"] as? Double {
//            r.lineWidth = strokeWidth
//        }
//        if let radiusFillColor = myLocationStyle["radiusFillColor"] as? [Int] {
//            r.fillColor = UIColor(red: CGFloat(radiusFillColor[0]/255), green: CGFloat(radiusFillColor[1]/255), blue: CGFloat(radiusFillColor[2]/255), alpha: 1.0)
//        }
//        
//        mapView.update(r)
    }
    
    func zoomGesturesEnabled(zoomGesturesEnabled: Bool) {
        mapView.isZoomEnabled = zoomGesturesEnabled
    }
    
    func scrollGesturesEnabled(scrollGesturesEnabled: Bool) {
        mapView.isScrollEnabled = scrollGesturesEnabled
    }
    
    func rotateGesturesEnabled(rotateGesturesEnabled: Bool) {
        mapView.isRotateEnabled = rotateGesturesEnabled
    }
    
    func tiltGesturesEnabled(tiltGesturesEnabled: Bool) {
        mapView.isRotateCameraEnabled = tiltGesturesEnabled
    }
    
    func allGesturesEnabled(allGesturesEnabled: Bool) {
        zoomGesturesEnabled(zoomGesturesEnabled: allGesturesEnabled)
        scrollGesturesEnabled(scrollGesturesEnabled: allGesturesEnabled)
        rotateGesturesEnabled(rotateGesturesEnabled: allGesturesEnabled)
        tiltGesturesEnabled(tiltGesturesEnabled: allGesturesEnabled)
        
    }
    
    func setScrollEnabled(scrollEnabled: Bool) {
        mapView.isScrollEnabled = scrollEnabled
    }
    
    
    func resizeImage(image: UIImage, targetSize: CGSize, alpha: CGFloat) -> UIImage? {
        let newSize = CGSize(width: targetSize.width, height: targetSize.height)
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect, blendMode: CGBlendMode.screen, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
