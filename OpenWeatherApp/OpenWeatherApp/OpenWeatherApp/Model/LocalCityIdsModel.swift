//
//  LocalCityIdsModel.swift
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/3/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

import UIKit

// MARK: - LocalCityIdsModel
struct LocalCityIdsElement: Codable {
    let id: Int
    let name, state, country: String
    let coord: CityCoord
}

// MARK: - Coord
struct CityCoord: Codable {
    let lon, lat: Double
}

typealias LocalCityIdsModel = [LocalCityIdsElement]
