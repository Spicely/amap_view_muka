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
    func setMapzoomControlsEnabled(zoomControlsEnabled: Bool)
    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool)
    func setMyLocationEnabled(myLocationEnabled: Bool)
    func setScaleEnabled(scaleEnabled: Bool)
    func setScrollEnabled(scrollEnabled: Bool)
    func setZoomEnabled(zoomEnabled: Bool)
    func setIndoorMap(indoorEnabled: Bool)
}

