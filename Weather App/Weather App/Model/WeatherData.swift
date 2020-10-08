//
//  WeatherData.swift
//  Weather App
//
//  Created by Alejandro Hernández Cortés on 29/09/20.
//  Copyright © 2020 Alejandro Hernández Cortés. All rights reserved.
//

import Foundation
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
