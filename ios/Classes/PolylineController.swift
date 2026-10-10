//
//  PolylineController.swift
//  amap_view_muka
//
//  Created by Spicely.
//

import Flutter
import MAMapKit
import UIKit

class PolylineModel {
    let id: String
    var points: [CLLocationCoordinate2D]
    var width: CGFloat
    var strokeColor: UIColor
    var isDotted: Bool
    var isGeodesic: Bool
    var lineJoinType: MALineJoinType
    var lineCapType: MALineCapType
    var polyline: MAPolyline?

    init(id: String,
         points: [CLLocationCoordinate2D],
         width: CGFloat,
         strokeColor: UIColor,
         isDotted: Bool,
         isGeodesic: Bool,
         lineJoinType: MALineJoinType,
         lineCapType: MALineCapType) {
        self.id = id
        self.points = points
        self.width = width
        self.strokeColor = strokeColor
        self.isDotted = isDotted
        self.isGeodesic = isGeodesic
        self.lineJoinType = lineJoinType
        self.lineCapType = lineCapType
    }
}

class PolylineController: NSObject {
    private var channel: FlutterMethodChannel
    private var mapView: MAMapView
    private var polylineDict = [String: PolylineModel]()
    private var overlayToId = NSMapTable<MAPolyline, NSString>(keyOptions: .weakMemory, valueOptions: .strongMemory)

    init(withChannel channel: FlutterMethodChannel, withMap mapView: MAMapView) {
        self.channel = channel
        self.mapView = mapView
        super.init()
    }

    func addPolylines(polylinesToAdd: [Any]) {
        for item in polylinesToAdd {
            if let opts = item as? [String: Any] {
                addPolyline(options: opts)
            }
        }
    }

    func addPolyline(options: [String: Any]) {
        guard let id = options["id"] as? String else { return }
        if polylineDict[id] != nil {
            updatePolyline(options: options)
            return
        }

        guard let model = parsePolylineModel(options: options) else { return }
        var coords = model.points
        let polyline = MAPolyline(coordinates: &coords, count: UInt(coords.count))
        model.polyline = polyline

        if let polyline = polyline {
            polylineDict[id] = model
            overlayToId.setObject(id as NSString, forKey: polyline)
            mapView.add(polyline)
        }
    }

    func updatePolyline(options: [String: Any]) {
        guard let id = options["id"] as? String else { return }
        guard let existingModel = polylineDict[id] else {
            addPolyline(options: options)
            return
        }

        if let oldPolyline = existingModel.polyline {
            mapView.remove(oldPolyline)
            overlayToId.removeObject(forKey: oldPolyline)
        }

        if let newModel = parsePolylineModel(options: options) {
            var coords = newModel.points
            let newPolyline = MAPolyline(coordinates: &coords, count: UInt(coords.count))
            newModel.polyline = newPolyline
            polylineDict[id] = newModel
            if let newPolyline = newPolyline {
                overlayToId.setObject(id as NSString, forKey: newPolyline)
                mapView.add(newPolyline)
            }
        }
    }

    func deletePolyline(options: [String: Any]) {
        guard let id = options["id"] as? String else { return }
        if let model = polylineDict.removeValue(forKey: id), let polyline = model.polyline {
            overlayToId.removeObject(forKey: polyline)
            mapView.remove(polyline)
        }
    }

    func clearPolylines() {
        for (_, model) in polylineDict {
            if let polyline = model.polyline {
                overlayToId.removeObject(forKey: polyline)
                mapView.remove(polyline)
            }
        }
        polylineDict.removeAll()
    }

    func rendererFor(overlay: MAOverlay) -> MAOverlayRenderer? {
        guard let polyline = overlay as? MAPolyline else { return nil }
        guard let id = overlayToId.object(forKey: polyline) as String?,
              let model = polylineDict[id] else {
            return nil
        }

        let renderer = MAPolylineRenderer(polyline: polyline)
        renderer?.strokeColor = model.strokeColor
        renderer?.lineWidth = model.width
        renderer?.lineJoinType = model.lineJoinType
        renderer?.lineCapType = model.lineCapType
        renderer?.isDottedLine = model.isDotted
        return renderer
    }

    private func parsePolylineModel(options: [String: Any]) -> PolylineModel? {
        guard let id = options["id"] as? String,
              let pointsData = options["points"] as? [[String: Any]] else {
            return nil
        }

        var coords = [CLLocationCoordinate2D]()
        for p in pointsData {
            if let lat = p["latitude"] as? Double, let lng = p["longitude"] as? Double {
                coords.append(CLLocationCoordinate2DMake(lat, lng))
            }
        }
        if coords.isEmpty { return nil }

        let width = CGFloat((options["width"] as? Double) ?? 10.0)
        let isDotted = (options["isDotted"] as? Bool) ?? false
        let isGeodesic = (options["isGeodesic"] as? Bool) ?? false

        var strokeColor = UIColor(red: 0.0, green: 230.0 / 255.0, blue: 118.0 / 255.0, alpha: 1.0)
        if let colorValue = options["colorValue"] as? Int64 {
            let a = CGFloat((colorValue >> 24) & 0xFF) / 255.0
            let r = CGFloat((colorValue >> 16) & 0xFF) / 255.0
            let g = CGFloat((colorValue >> 8) & 0xFF) / 255.0
            let b = CGFloat(colorValue & 0xFF) / 255.0
            strokeColor = UIColor(red: r, green: g, blue: b, alpha: a)
        } else if let colorArr = options["color"] as? [Int], colorArr.count >= 4 {
            strokeColor = UIColor(
                red: CGFloat(colorArr[0]) / 255.0,
                green: CGFloat(colorArr[1]) / 255.0,
                blue: CGFloat(colorArr[2]) / 255.0,
                alpha: CGFloat(colorArr[3]) / 255.0
            )
        }

        var lineJoin: MALineJoinType = .round
        if let join = options["lineJoinType"] as? Int {
            switch join {
            case 0: lineJoin = .bevel
            case 1: lineJoin = .miter
            default: lineJoin = .round
            }
        }

        var lineCap: MALineCapType = .round
        if let cap = options["lineCapType"] as? Int {
            switch cap {
            case 0: lineCap = .butt
            case 1: lineCap = .square
            default: lineCap = .round
            }
        }

        return PolylineModel(
            id: id,
            points: coords,
            width: width,
            strokeColor: strokeColor,
            isDotted: isDotted,
            isGeodesic: isGeodesic,
            lineJoinType: lineJoin,
            lineCapType: lineCap
        )
    }
}
