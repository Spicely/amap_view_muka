//
//  AmapOptionsSink.swift
//  amap_view_muka
//
//  Created by Spice ly on 2022/5/18.
//


protocol AmapOptionsSink {
    func setCameraPosition(camera: CameraPosition)
    func setCompassEnabled(compassEnabled: Bool)
    func setMapType(mapType: Int)
    func setMapLanguage(language: Int)
    func setMapZoomLevel(zommLevel: Double)
    func setMapIndoorMap(indoorMap: Bool)
    func setLogoPosition(logoPosition: Int)
    func setMapzoomControlsEnabled(zoomControlsEnabled: Bool)
    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool)
    func setMyLocationStyle(myLocationStyle: [String: Any])
    func scrollGesturesEnabled(scrollGesturesEnabled: Bool)
    func setScrollEnabled(scrollEnabled: Bool)
    func zoomGesturesEnabled(zoomGesturesEnabled: Bool)
    func setIndoorMap(indoorEnabled: Bool)
    func rotateGesturesEnabled(rotateGesturesEnabled: Bool)
    func tiltGesturesEnabled(tiltGesturesEnabled: Bool)
    func allGesturesEnabled(allGesturesEnabled: Bool)
}

