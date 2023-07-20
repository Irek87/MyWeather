//
//  NetworkManager.swift
//  MyWeather
//
//  Created by Reek i on 20.07.2023.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: fetchCLCurrentWeatherData
    func fetchCLCurrentWeatherData(latitude: Double, longtitude: Double, completion: @escaping (CurrentWeatherData) -> ()) {
        guard let urlCurrentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        
        URLSession.shared.dataTask(with: urlCurrentWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(currentWeatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: fetchCLFiveDaysWeatherData
    func fetchCLFiveDaysWeatherData(latitude: Double, longtitude: Double, completion: @escaping (FiveDaysWeatherData) -> ()) {
        guard let urlFiveDaysWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude.description)&lon=\(longtitude.description)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        
        URLSession.shared.dataTask(with: urlFiveDaysWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let fiveDaysWeatherData = try JSONDecoder().decode(FiveDaysWeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(fiveDaysWeatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: fetchDesiredCityCurrentWeatherData
    func fetchDesiredCityCurrentWeatherData(desiredCity: String, completion: @escaping (CurrentWeatherData) -> ()) {
        guard let urlCurrentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(desiredCity)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        
        URLSession.shared.dataTask(with: urlCurrentWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(currentWeatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    // MARK: fetchDesiredCityFiveDaysWeatherData
    func fetchDesiredCityFiveDaysWeatherData(desiredCity: String, completion: @escaping (FiveDaysWeatherData) -> ()) {
        guard let urlFiveDaysWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(desiredCity)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        
        URLSession.shared.dataTask(with: urlFiveDaysWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                let fiveDaysWeatherData = try JSONDecoder().decode(FiveDaysWeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(fiveDaysWeatherData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
