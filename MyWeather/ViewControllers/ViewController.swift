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
    let currentWeatherView = CurrentWeatherView()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    // MARK: Variables
    let searchController = UISearchController()
    let locationManager = CLLocationManager()
    var fiveDaysWeatherData: FiveDaysWeatherData?
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundImageView()
        setupCurrentLocationButton()
        setupSearchController()
        setupCurrentWeatherView()
        
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
    
    // MARK: setupCurrentWeatherView()
    private func setupCurrentWeatherView() {
        view.addSubview(currentWeatherView)
        currentWeatherView.translatesAutoresizingMaskIntoConstraints = false
        currentWeatherView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        currentWeatherView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        currentWeatherView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        currentWeatherView.heightAnchor.constraint(equalToConstant: 304).isActive = true
        
        
        currentWeatherView.configure()
    }

    // MARK: setupCollectionView
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        
        collectionView.topAnchor.constraint(equalTo: currentWeatherView.bottomAnchor, constant: 20).isActive = true
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
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.delegate = self
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.pausesLocationUpdatesAutomatically = false
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    // MARK: updateCurrentLocationWeatherInfo
    private func updateCurrentLocationWeatherInfo(latitude: Double, longtitude: Double) {
        NetworkManager.shared.fetchData(latitude: latitude, longtitude: longtitude) { [unowned self] currentData in
            currentWeatherView.updateUI(with: currentData)
        } completionForecastData: { [unowned self] fiveDaysData in
            fiveDaysWeatherData = fiveDaysData
            collectionView.reloadData()
        }
    }
    
    // MARK: updateDesiredCityWeatherInfo
    private func updateDesiredCityWeatherInfo(desiredCity: String) {
        NetworkManager.shared.fetchData(city: desiredCity) { [unowned self] currentData in
            currentWeatherView.updateUI(with: currentData)
        } completionForecastData: { [unowned self] fiveDaysData in
            fiveDaysWeatherData = fiveDaysData
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

