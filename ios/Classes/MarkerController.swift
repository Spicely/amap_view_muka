//
//  MarkerController.swift
//  amap_view_muka
//
//  Created by Spice ly on 2022/5/18.
//
import MAMapKit

class MarkerController: NSObject {
    
    var mapView: MAMapView
    var channel: FlutterMethodChannel
    
    // markerId(dart端)与marker的映射关系
    var markerIdToMarker = [String: MAPointAnnotation]()
    
    // markerId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
    var markerIdToOptions = [String: Any]()
    
    init(withChannel channel: FlutterMethodChannel, withMap mapView: MAMapView) {
        self.channel = channel
        self.mapView = mapView
        super.init()
    }
    
    func addMarker(options: Any) {
        if let opts = options as? [String: Any] {
            let point = MAPointAnnotation()
            if let position = opts["position"] as? [String: Double] {
                point.coordinate = CLLocationCoordinate2D(latitude: position["latitude"]!, longitude: position["longitude"]!)
            }
//            if let infoWindow = opts["infoWindow"] as? [String: Any] {
//                point.title = infoWindow["title"] as? String
//                point.subtitle = infoWindow["snippet"] as? String
//            }
            let markerId = opts["id"] as! String
            
            // 保存状态
            markerIdToMarker[markerId] = point
            markerIdToOptions[markerId] = opts
            
            mapView.addAnnotation(point)
        }
    }
    
    func updateMarker(options: [String: Any]) {
        let id = options["id"] as! String
        if let point = markerIdToMarker[id] {
            let position = options["position"] as! [String: Double]
            point.coordinate = CLLocationCoordinate2D(latitude: position["latitude"]!, longitude: position["longitude"]!)
            if markerIdToOptions[id] != nil {
                markerIdToOptions[id] = options
            }
            mapView.addAnnotation(point)
        }
    }
    
    func changeMarker(options: Any) {
        if let opts = options as? [String: Any] {
            let markerId = opts["markerId"] as! String
            if let point = markerIdToMarker[markerId] {
                if let position = opts["position"] as? [String: Double] {
                    point.coordinate = CLLocationCoordinate2D(latitude: position["latitude"]!, longitude: position["longitude"]!)
                }
            }
        }
    }
    
    func addMarkers(markersToAdd: [Any]) {
        for o in markersToAdd {
            addMarker(options: o)
        }
    }
    
    func changeMarkers(markersToChange: [Any]) {
        for o in markersToChange {
            changeMarker(options: o)
        }
    }
    
    func removeMarkers(markerIdsToRemove: [Any]) {
        for o in markerIdsToRemove {
            mapView.removeAnnotation(markerIdToMarker[o as! String])
            markerIdToMarker.removeValue(forKey: o as! String)
            markerIdToOptions.removeValue(forKey: o as! String)
        }
    }
}
