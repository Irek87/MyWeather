//
//  DataModels.swift
//  MyWeather
//
//  Created by Reek i on 30.06.2023.
//

import Foundation

/*
 У тебя все поля optional.
 Это не очень хорошо, подумай какие поля действительно optional.
 Если парсинг падает – подумай как обработать ошибки.
 */
struct CurrentWeatherData: Decodable {
  /*
   Отдельно про массивы.
   у тебя в таком случае есть три состояния:
   1. Отсутствие массива – nil
   2. Пустой массив – []
   3. Не пустой массив – [x]

   Это три разных состояния, и тебя нужно их уметь различать.
   Обычно избавляются от nil (первый сценарий), если нужно по умолчанию массив делают пустым.
   */
    let weather: [Weather]?
    let main: Main?
    let name: String?
    let sys: Sys?
}

struct Sys: Decodable {
    let sunrise: TimeInterval?
    let sunset: TimeInterval?
}

struct Main: Decodable {
    let temp: Double?
    /*
     Тут желательно camelCase,
     можно использовать СodingKeys
     https://nemecek.be/blog/90/how-to-decode-snake-case-with-codable
     */
    let feels_like: Double?
    let temp_min: Double?
    let temp_max: Double?
}

struct Weather: Decodable {
    let main: String?
    let description: String?
    let icon: String?
}

struct FiveDayWeatherData: Decodable {
    let list: [List]?
}

struct List: Decodable {
    let dt: TimeInterval?
    let main: Main?
    let weather: [Weather]?
}
