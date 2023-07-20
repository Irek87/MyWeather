//
//  ViewController.swift
//  MyWeather
//
//  Created by Reek i on 30.06.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var weatherConditionsLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var highTemperatureLabel: UILabel!
    @IBOutlet var lowTemperatureLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var locationButton: UIButton!
    
    // MARK: Variables
    let locationManager = CLLocationManager()
    var currentWeatherData: CurrentWeatherData!
    var fiveDaysWeatherData = FiveDaysWeatherData(list: nil)
    let formatter = DateFormatter()

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.isHidden = true
        startLocationManager()
    }
    
    // MARK: touchesBegan
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        searchBar.isHidden = true
        searchButton.isHidden = false
        locationButton.isHidden = false
    }
    
    // MARK: IBActions
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchButton.isHidden = true
        locationButton.isHidden = true
        searchBar.isHidden = false
    }
    @IBAction func locationButtonPressed(_ sender: Any) {
        if let latitude = locationManager.location?.coordinate.latitude,
           let longtitude = locationManager.location?.coordinate.longitude {
            updateCurrentLocationWeatherInfo(latitude: latitude, longtitude: longtitude)
        }
    }
    
    // MARK: startLocationManager
    func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: updateCurrentWeather
    func updateCurrentWeatherView() {
        cityNameLabel.text = currentWeatherData.name ?? "City not found"
        weatherConditionsLabel.text = currentWeatherData.weather?.first?.main ?? "-"
        if let currentTemperature = currentWeatherData.main?.temp {
            temperatureLabel.text = Int(currentTemperature).description + "℃"
        } else {
            temperatureLabel.text = "℃"
        }
        if let highTemperature = currentWeatherData.main?.temp_max {
            highTemperatureLabel.text = "H: " + Int(highTemperature).description + "°"
        } else {
            highTemperatureLabel.text = ""
        }
        if let lowTemperature = currentWeatherData.main?.temp_min {
            lowTemperatureLabel.text = "L: " + Int(lowTemperature).description + "°"
        } else {
            lowTemperatureLabel.text = ""
        }
        
        formatter.dateFormat = "HH:mm"
        if let sunriseTimeInterval = currentWeatherData.sys?.sunrise {
            let dateSunrise = Date(timeIntervalSince1970: sunriseTimeInterval)
            sunriseLabel.text = formatter.string(from: dateSunrise)
        } else {
            sunriseLabel.text = ""
        }
        if let sunsetTimeInterval = currentWeatherData.sys?.sunset {
            let dateSunset = Date(timeIntervalSince1970: sunsetTimeInterval)
            sunsetLabel.text = formatter.string(from: dateSunset)
        } else {
            sunsetLabel.text = ""
        }
    }
    
    // MARK: updateCurrentLocationWeatherInfo
    func updateCurrentLocationWeatherInfo(latitude: Double, longtitude: Double) {
        NetworkManager.shared.fetchCLCurrentWeatherData(latitude: latitude, longtitude: longtitude) { [unowned self] currentWeatherData in
            self.currentWeatherData = currentWeatherData
            updateCurrentWeatherView()
        }
        
        NetworkManager.shared.fetchCLFiveDaysWeatherData(latitude: latitude, longtitude: longtitude) { [unowned self] fiveDaysWeatherData in
            self.fiveDaysWeatherData = fiveDaysWeatherData
            collectionView.reloadData()
        }
    }
    
    // MARK: updateDesiredCityWeatherInfo
    func updateDesiredCityWeatherInfo(desiredCity: String) {
        NetworkManager.shared.fetchDesiredCityCurrentWeatherData(desiredCity: desiredCity) { [unowned self] currentWeatherData in
            self.currentWeatherData = currentWeatherData
            updateCurrentWeatherView()
        }
                
        NetworkManager.shared.fetchDesiredCityFiveDaysWeatherData(desiredCity: desiredCity) { [unowned self] fiveDaysWeatherData in
            self.fiveDaysWeatherData = fiveDaysWeatherData
            collectionView.reloadData()
        }
    }
}

// MARK: CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            updateCurrentLocationWeatherInfo(latitude: lastLocation.coordinate.latitude, longtitude: lastLocation.coordinate.longitude)
        }
    }
}

// MARK: UICollectionView
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fiveDaysWeatherData.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        formatter.dateFormat = "dd.MM    HH"
        let date =  Date(timeIntervalSince1970: fiveDaysWeatherData.list?[indexPath.item].dt ?? 0)
        cell.dateTimeLabel.text = formatter.string(from: date) + " h"
        
        cell.iconImageView.image = UIImage(named: fiveDaysWeatherData.list?[indexPath.item].weather?.first?.icon ?? "")
        cell.temperatureLabel.text = Int(fiveDaysWeatherData.list?[indexPath.item].main?.temp ?? 0).description + "°"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 120, height: 60)
    }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let desiredCity = searchBar.text {
            updateDesiredCityWeatherInfo(desiredCity: desiredCity)
            searchBar.isHidden = true
            searchButton.isHidden = false
            locationButton.isHidden = false
            searchBar.endEditing(true)
            searchBar.text = ""
        }
    }
}
