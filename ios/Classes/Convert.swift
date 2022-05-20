//
//  Convert.swift
//  amap_view_muka
//
//  Created by Spice ly on 2022/5/18.
//

import MAMapKit

let jsonEncoder = JSONEncoder()
let jsonDecoder = JSONDecoder()

class Convert {
    class func interpretMapOptions(options: Any?, delegate: AmapOptionsSink) {
        if let opts = options as? [String: Any] {
            if let cameraPosition = opts["cameraPosition"] as? [String: Any] {
                delegate.setCameraPosition(camera: toCameraPosition(opts: cameraPosition))
            }
            if let type = opts["type"] as? Int {
                delegate.setMapType(mapType: type)
            }
            if let language = opts["language"] as? Int {
                delegate.setMapLanguage(language: language)
            }
            if let zoomLevel = opts["zoomLevel"] as? Double {
                delegate.setMapZoomLevel(zommLevel: zoomLevel)
            }
            if let indoorMap = opts["indoorMap"] as? Bool {
                delegate.setMapIndoorMap(indoorMap: indoorMap)
            }
            if let compassEnabled = opts["compassEnabled"] as? Bool {
                delegate.setCompassEnabled(compassEnabled: compassEnabled)
            }
            if let myLocationStyle = opts["myLocationStyle"] as? [String: Any] {
                delegate.setMyLocationStyle(myLocationStyle: myLocationStyle)
            }
            if let logoPosition = opts["logoPosition"] as? Int {
                delegate.setLogoPosition(logoPosition: logoPosition)
            }
            if let zoomGesturesEnabled = opts["zoomGesturesEnabled"] as? Bool {
                delegate.zoomGesturesEnabled(zoomGesturesEnabled: zoomGesturesEnabled)
            }
            if let scrollGesturesEnabled = opts["scrollGesturesEnabled"] as? Bool {
                delegate.scrollGesturesEnabled(scrollGesturesEnabled: scrollGesturesEnabled)
            }
            if let rotateGesturesEnabled = opts["rotateGesturesEnabled"] as? Bool {
                delegate.rotateGesturesEnabled(rotateGesturesEnabled: rotateGesturesEnabled)
            }
            if let tiltGesturesEnabled = opts["tiltGesturesEnabled"] as? Bool {
                delegate.tiltGesturesEnabled(tiltGesturesEnabled: tiltGesturesEnabled)
            }
            if let allGesturesEnabled = opts["allGesturesEnabled"] as? Bool {
                delegate.allGesturesEnabled(allGesturesEnabled: allGesturesEnabled)
            }
        }
    }
    
    class func toCameraPosition(opts: [String: Any]) -> CameraPosition {
        let bearing = opts["bearing"] as! Double
        let tilt = opts["tilt"] as! Double
        let zoom = opts["zoom"] as! Double
        let target = toLatLng(options: opts["latLng"]!)
        let duration = opts["duration"] as? Int ?? 0
        return CameraPosition(bearing: bearing, tilt: tilt, zoom: zoom, target: target, duration: duration)
    }

    class func toLatLng(options: Any) -> LatLng {
        let opts = options as! [String: Any]
        let latitude = opts["latitude"] as! Double
        let longitude = opts["longitude"] as! Double
        return LatLng(latitude: latitude, longitude: longitude)
    }
    
    class func toCLLocationCoordinate2D(options: Any) -> CLLocationCoordinate2D {
        let opts = options as! [String: Any]
        let latitude = opts["latitude"] as! Double
        let longitude = opts["longitude"] as! Double
        return CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
    }
    
    class func toMACoordinateSpan(options: Any) -> MACoordinateSpan {
        let opts = options as! [String: Any]
        let latitude = opts["latitude"] as! Double
        let longitude = opts["longitude"] as! Double
        return MACoordinateSpan.init(latitudeDelta: latitude, longitudeDelta: longitude)
    }
    
    class func toJson(latLng: LatLng) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["latitude"] = latLng.latitude
        data["longitude"] = latLng.longitude
        return data
    }

    class func toJson(position: CameraPosition) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["target"] = toJson(latLng: position.target)
        data["bearing"] = position.bearing
        data["tilt"] = position.tilt
        data["zoom"] = position.zoom
        data["duration"] = position.duration
        return data
    }
    
    class func toJson(location: CLLocationCoordinate2D) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["latitude"] = location.latitude
        data["longitude"] = location.longitude
        return data
    }
}
