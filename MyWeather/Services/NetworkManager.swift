//
//  NetworkManager.swift
//  MyWeather
//
//  Created by Reek i on 20.07.2023.
//

import UIKit

class NetworkManager: MessageProtocol {
    static let shared = NetworkManager()

    private var currentWeatherUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "d5b36c5ddd04779bb494acf04cc0f9ae"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components
    }()
    
    private var forecastUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        components.queryItems = [
            URLQueryItem(name: "appid", value: "d5b36c5ddd04779bb494acf04cc0f9ae"),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components
    }()
    
    
    private init() {}
    
    func fetchData(
        latitude: Double? = nil,
        longtitude: Double? = nil,
        city: String? = nil,
        completionCurrentData: @escaping (CurrentWeatherData?) -> (),
        completionForecastData: @escaping (FiveDaysWeatherData?) -> ()
    ) {
        if let latitude = latitude, let longtitude = longtitude {
            currentWeatherUrlComponents.queryItems?.insert(URLQueryItem(name: "lat", value: "\(latitude)"), at: 0)
            currentWeatherUrlComponents.queryItems?.insert(URLQueryItem(name: "lon", value: "\(longtitude)"), at: 1)
            
            forecastUrlComponents.queryItems?.insert(URLQueryItem(name: "lat", value: "\(latitude)"), at: 0)
            forecastUrlComponents.queryItems?.insert(URLQueryItem(name: "lon", value: "\(longtitude)"), at: 1)
            
            guard let currentWeatherURL = currentWeatherUrlComponents.url,
                  let fiveDaysWeatherURL = forecastUrlComponents.url else { return }
            
            fetchWeatherData(url: currentWeatherURL, completion: completionCurrentData)
            fetchWeatherData(url: fiveDaysWeatherURL, completion: completionForecastData)
        } else if let city = city {
            currentWeatherUrlComponents.queryItems?.insert(URLQueryItem(name: "q", value: "\(city)"), at: 0)
            forecastUrlComponents.queryItems?.insert(URLQueryItem(name: "q", value: "\(city)"), at: 0)
            
            guard let currentWeatherURL = currentWeatherUrlComponents.url,
                  let fiveDaysWeatherURL = forecastUrlComponents.url else { return }
            
            fetchWeatherData(url: currentWeatherURL, completion: completionCurrentData)
            fetchWeatherData(url: fiveDaysWeatherURL, completion: completionForecastData)
        }
    }
    
    // MARK: getWeatherData
    private func fetchWeatherData<T: Decodable>(url: URL, completion: @escaping (T) -> ()) {
        URLSession.shared.dataTask(with: url) { [unowned self] data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlert(with: "Please check your internet connection!")
                }
            }

            guard let data = data else {
                return
            }
            do {
                let weatherData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    print("\n=============Data loaded=============\n")
                    completion(weatherData)
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(with: "Something wrong. Please try again!")
                }
            }
        }.resume()
    }
}
