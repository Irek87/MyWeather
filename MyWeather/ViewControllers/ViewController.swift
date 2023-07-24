//
//  ViewController.swift
//  MyWeather
//
//  Created by Reek i on 30.06.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
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
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // MARK: Variables
    let searchController = UISearchController()
    let locationManager = CLLocationManager()
    var currentWeatherData: CurrentWeatherData?
    var fiveDaysWeatherData: FiveDaysWeatherData?
    let formatter = DateFormatter()

    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundImageView()
        setupCurrentLocationButton()
        setupSearchController()
        setupCityNameLabel()
        setupWeatherConditionsLabel()
        setupTemperatureLabel()
        setupHighAndLowTempStack()
        setupSunriseSunsetStackView()
        
        setupCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

//        startLocationManager()
    }
    
    // MARK: setupBackgroundImageView
    private func setupBackgroundImageView() {
        //background imageView
        let backImageView: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "back_weather"))
            imageView.frame = view.frame
            imageView.contentMode = .scaleToFill
            return imageView
        }()
        view.addSubview(backImageView)
    }
     
    // MARK: setupCurrentLocationButton
    private func setupCurrentLocationButton() {
        //currentLocation button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "location.circle"),
            style: .plain,
            target: self,
            action: #selector(locationButtonPressed))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // MARK: setupSearchController
    private func setupSearchController() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
//        searchController.obscuresBackgroundDuringPresentation = false // Нужно ли тут?
        searchController.searchBar.placeholder = "Search city"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.searchTextField.textColor = .white
    }
    
    // MARK: setupCityNameLabel
    private func setupCityNameLabel() {
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cityNameLabel.numberOfLines = 0
        cityNameLabel.text = "Your City"
        cityNameLabel.font = UIFont(name: "Georgia-bold", size: 40)
        cityNameLabel.textColor = .white
        cityNameLabel.textAlignment = .center
        view.addSubview(cityNameLabel)
        cityNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        cityNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cityNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
    
    // MARK: setupWeatherConditionsLabel
    private func setupWeatherConditionsLabel() {
        weatherConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherConditionsLabel.text = "weather conditions"
        weatherConditionsLabel.font = UIFont(name: "Georgia", size: 20)
        weatherConditionsLabel.textColor = .white
        view.addSubview(weatherConditionsLabel)
        weatherConditionsLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 20).isActive = true
        weatherConditionsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: setupTemperatureLabel
    private func setupTemperatureLabel() {
        temperatureLabel.translatesAutoresizingMaskIntoConstraints = false
        temperatureLabel.text = "--°C"
        temperatureLabel.font = UIFont(name: "Georgia-bold", size: 50)
        temperatureLabel.textColor = .white
        view.addSubview(temperatureLabel)
        temperatureLabel.topAnchor.constraint(equalTo: weatherConditionsLabel.bottomAnchor, constant: 20).isActive = true
        temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        
        view.addSubview(highAndLowTempStackView)
        highAndLowTempStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 10).isActive = true
        highAndLowTempStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // MARK: setupSunriseSunsetStackView
    private func setupSunriseSunsetStackView() {
        sunriseSunsetStackView.translatesAutoresizingMaskIntoConstraints = false
        sunriseSunsetStackView.axis = .horizontal
        sunriseSunsetStackView.addArrangedSubview(sunriseStackView)
        configureSunriseStackView()
        sunriseSunsetStackView.addArrangedSubview(sunsetStackView)
        configureSunsetStackView()
        
        view.addSubview(sunriseSunsetStackView)
        sunriseSunsetStackView.topAnchor.constraint(equalTo: highAndLowTempStackView.bottomAnchor, constant: 30).isActive = true
        sunriseSunsetStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
    
    // MARK: setupCollectionView
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        
        collectionView.topAnchor.constraint(equalTo: sunriseSunsetStackView.bottomAnchor, constant: 20).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
    }
    
    // MARK: locationButtonPressed
    @objc private func locationButtonPressed() {
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
        fiveDaysWeatherData?.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        guard let list = fiveDaysWeatherData?.list[indexPath.item] else { return cell }
        cell.configure(with: list)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 80, height: 60)
    }
}

// MARK: UISearchControllerDelegate
extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let desiredCity = searchBar.text else { return }
        updateDesiredCityWeatherInfo(desiredCity: desiredCity)
        searchBar.text = ""
        searchController.dismiss(animated: true)
    }
}
