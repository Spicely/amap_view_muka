//
//  Options.swift
//  amap_view_muka
//
//  Created by Spice ly on 2022/5/18.
//

struct LatLng: Codable {
    let latitude: Double
    let longitude: Double
}

struct CameraPosition: Codable {
    let bearing: Double
    let tilt: Double
    let zoom: Double
    let target: LatLng
    let duration: Int
}

