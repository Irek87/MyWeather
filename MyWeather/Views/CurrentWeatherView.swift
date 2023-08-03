//
//  CurrentWeatherView.swift
//  MyWeather
//
//  Created by Reek i on 31.07.2023.
//

import UIKit

class CurrentWeatherView: UIView {
    let formatter = DateFormatter()
    
    // MARK: UI constants
    let cityNameLabel = UILabel()
    let weatherConditionsLabel = UILabel()
    let temperatureLabel = UILabel()
    let highAndLowTempStackView = UIStackView()
    let highTemperatureLabel = UILabel()
    let lowTemperatureLabel = UILabel()
    let sunriseSunsetStackView = UIStackView()
    let sunriseStackView = UIStackView()
    let sunriseImageView = UIImageView()
    let sunriseLabel = UILabel()
    let sunsetStackView = UIStackView()
    let sunsetImageView = UIImageView()
    let sunsetLabel = UILabel()
    
    // MARK: configure View
    func configure() {
        setupCityNameLabel()
        setupWeatherConditionsLabel()
        setupTemperatureLabel()
        setupHighAndLowTempStack()
        setupSunriseSunsetStackView()
    }
    
    // MARK: setupCityNameLabel
    private func setupCityNameLabel() {
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.numberOfLines = 0
        cityNameLabel.text = "Your City"
        cityNameLabel.font = UIFont(name: "Georgia-bold", size: 40)
        cityNameLabel.textColor = .white
        cityNameLabel.textAlignment = .center
        addSubview(cityNameLabel)
        cityNameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cityNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9).isActive = true
    }
    
    // MARK: setupWeatherConditionsLabel
    private func setupWeatherConditionsLabel() {
        weatherConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherConditionsLabel.text = "weather conditions"
        weatherConditionsLabel.font = UIFont(name: "Georgia", size: 20)
        weatherConditionsLabel.textColor = .white
        addSubview(weatherConditionsLabel)
        weatherConditionsLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 20).isActive = true
        weatherConditionsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: setupTemperatureLabel
    private func setupTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.text = "--°C"
        temperatureLabel.font = UIFont(name: "Georgia-bold", size: 50)
        temperatureLabel.textColor = .white
        addSubview(temperatureLabel)
        temperatureLabel.topAnchor.constraint(equalTo: weatherConditionsLabel.bottomAnchor, constant: 20).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: setupHighAndLowTempStack
    private func setupHighAndLowTempStack() {
        highTemperatureLabel.text = "H: --°C"
        highTemperatureLabel.font = UIFont(name: "Georgia", size: 20)
        highTemperatureLabel.textColor = .white
        lowTemperatureLabel.text = "L: --°C"
        lowTemperatureLabel.font = UIFont(name: "Georgia", size: 20)
        lowTemperatureLabel.textColor = .white
        highAndLowTempStackView.translatesAutoresizingMaskIntoConstraints = false
        highAndLowTempStackView.axis = .horizontal
        highAndLowTempStackView.spacing = 10
        highAndLowTempStackView.addArrangedSubview(highTemperatureLabel)
        highAndLowTempStackView.addArrangedSubview(lowTemperatureLabel)
        
        addSubview(highAndLowTempStackView)
        highAndLowTempStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10).isActive = true
        highAndLowTempStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: setupSunriseSunsetStackView
    private func setupSunriseSunsetStackView() {
        sunriseSunsetStackView.translatesAutoresizingMaskIntoConstraints = false
        sunriseSunsetStackView.axis = .horizontal
        sunriseSunsetStackView.addArrangedSubview(sunriseStackView)
        configureSunriseStackView()
        sunriseSunsetStackView.addArrangedSubview(sunsetStackView)
        configureSunsetStackView()
        
        addSubview(sunriseSunsetStackView)
        sunriseSunsetStackView.topAnchor.constraint(equalTo: highAndLowTempStackView.bottomAnchor, constant: 30).isActive = true
        sunriseSunsetStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    // MARK: configureSunriseStackView
    private func configureSunriseStackView() {
        sunriseImageView.image = UIImage(named: "sunrise_60p")
        sunriseLabel.text = "hh:mm"
        sunriseLabel.font = UIFont(name: "Georgia", size: 20)
        sunriseLabel.textColor = .white
        //        sunriseStackView.translatesAutoresizingMaskIntoConstraints = false
        sunriseStackView.axis = .vertical
        sunriseStackView.spacing = 4
        sunriseStackView.alignment = .center
        sunriseStackView.addArrangedSubview(sunriseImageView)
        sunriseStackView.addArrangedSubview(sunriseLabel)
    }
    
    // MARK: configureSunsetStackView
    private func configureSunsetStackView() {
        sunsetImageView.image = UIImage(named: "sunset _60p")
        sunsetLabel.text = "hh:mm"
        sunsetLabel.font = UIFont(name: "Georgia", size: 20)
        sunsetLabel.textColor = .white
        //        sunsetStackView.translatesAutoresizingMaskIntoConstraints = false
        sunsetStackView.axis = .vertical
        sunsetStackView.spacing = 4
        sunsetStackView.alignment = .center
        sunsetStackView.addArrangedSubview(sunsetImageView)
        sunsetStackView.addArrangedSubview(sunsetLabel)
    }
    
    // MARK: update UI
    func updateUI(with currentWeatherData: CurrentWeatherData?) {
        cityNameLabel.text = currentWeatherData?.name ?? "City not found"
        weatherConditionsLabel.text = currentWeatherData?.weather.first?.main
        if let currentTemperature = currentWeatherData?.main.temp {
            temperatureLabel.text = Int(currentTemperature).description + "℃"
        } else {
            temperatureLabel.text = "℃"
        }
        if let highTemperature = currentWeatherData?.main.tempMax {
            highTemperatureLabel.text = "H: " + Int(highTemperature).description + "°"
        } else {
            highTemperatureLabel.text = ""
        }
        if let lowTemperature = currentWeatherData?.main.tempMin {
            lowTemperatureLabel.text = "L: " + Int(lowTemperature).description + "°"
        } else {
            lowTemperatureLabel.text = ""
        }
        
        formatter.dateFormat = "HH:mm"
        if let sunriseTimeInterval = currentWeatherData?.sys.sunrise {
            let dateSunrise = Date(timeIntervalSince1970: sunriseTimeInterval)
            sunriseLabel.text = formatter.string(from: dateSunrise)
        } else {
            sunriseLabel.text = ""
        }
        if let sunsetTimeInterval = currentWeatherData?.sys.sunset {
            let dateSunset = Date(timeIntervalSince1970: sunsetTimeInterval)
            sunsetLabel.text = formatter.string(from: dateSunset)
        } else {
            sunsetLabel.text = ""
        }
    }
}
