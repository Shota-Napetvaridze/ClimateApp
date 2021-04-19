//
//  WeatherData.swift
//  ClimateApp
//
//  Created by MacBook Pro on 16.04.21.
//

import UIKit

struct WeatherData : Codable{
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
