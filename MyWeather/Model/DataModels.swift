//
//  DataModels.swift
//  MyWeather
//
//  Created by Reek i on 30.06.2023.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
    let sys: Sys
}

struct Sys: Decodable {
    let sunrise: TimeInterval
    let sunset: TimeInterval
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        }
}

struct Weather: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct FiveDaysWeatherData: Decodable {
    let list: [List]
}

struct List: Decodable {
    let dt: TimeInterval
    let main: Main
    let weather: [Weather]
}
