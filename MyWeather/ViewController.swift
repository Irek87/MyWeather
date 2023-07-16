//
//  ViewController.swift
//  MyWeather
//
//  Created by Reek i on 30.06.2023.
//

import UIKit
import CoreLocation

/*
 Давай разбивать этот класс;
 Напрашиваются истории про:
 1. Отдельный view для CurrentWeather
 2. Вынести сетевые запросы в отдельные классы в виде переиспользуемой логики
 3. Отдельный обработчик UICollectionView, который реализует delegate & datasource
 4. LocationManager, который возьмет на себя работу с геолокацией.
 5. Попытаться прикрутить UISearchController, чтобы не реализовать UI поиска вручную.
 */
class ViewController: UIViewController {

  // Давай попробуем сверстать кодом :)
  // Через Storyboard сейчас уже не делают особо

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
  // Опасная история, лучше делать CurrentWeatherData?, но про структуры на нужно отдельно поговорить
    var currentWeatherData: CurrentWeatherData!
    var fiveDayWeatherData = FiveDayWeatherData(list: nil)
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

      /* Xcode жалуется
       This method can cause UI unresponsiveness if invoked on the main thread. Instead, consider waiting for the `-locationManagerDidChangeAuthorization:` callback and checking `authorizationStatus` first
       */
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
        }
    }
    
    // MARK: updateCurrentWeather
  /*
   Тут прям напрашивается, чтобы у тебя был отдельный CurrentWeatherView,
   в котором будет спрятана логика по скачивание данных и обновление view.
   */
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
      /* Проблема 1 – руками прописывать query не безопасно, легко опечататься, можно забыть кодировку и тд. Есть API, который может собрать тебе endpoint – https://developer.apple.com/documentation/foundation/urlcomponents Проблема 2 – longtitude.description. Конкретно здесь это ок, но этот метод дает строку, описывающую объект или структуру. То есть вызов этого метода у другого объекта может привести к другим результатам и лучше явно приводить к строке. В данном случае ты можешь использовать string interpolation: `?lat=\(latitude)&lo` (без .description)
       */

        guard let urlCurrentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude.description)&lon=\(longtitude.description)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric"),
            let urlFiveDaysWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude.description)&lon=\(longtitude.description)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        let task1 = URLSession.shared.dataTask(with: urlCurrentWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self.currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.updateCurrentWeatherView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        let task2 = URLSession.shared.dataTask(with: urlFiveDaysWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self.fiveDayWeatherData = try JSONDecoder().decode(FiveDayWeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task1.resume()
        task2.resume()
    }
    
    // MARK: updateDesiredCityWeatherInfo
    func updateDesiredCityWeatherInfo(desiredCity: String) {
      /*
       Те же проблемы. Рекомендую попробовать написать generic метод, куда можно вынести общую логику.
       Так логика по загрузке у тебя дублируется;
       func fetchData<T: Decodable>(url: URL, completion: () -> Result<T, Error>)
       */
        guard let urlCurrentWeather = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(desiredCity)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric"),
            let urlFiveDaysWeather = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(desiredCity)&appid=d5b36c5ddd04779bb494acf04cc0f9ae&units=metric") else { return }
        let task1 = URLSession.shared.dataTask(with: urlCurrentWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self.currentWeatherData = try JSONDecoder().decode(CurrentWeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.updateCurrentWeatherView()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        let task2 = URLSession.shared.dataTask(with: urlFiveDaysWeather) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                self.fiveDayWeatherData = try JSONDecoder().decode(FiveDayWeatherData.self, from: data)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task1.resume()
        task2.resume()
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
        fiveDayWeatherData.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        
        formatter.dateFormat = "dd.MM    HH"
        let date =  Date(timeIntervalSince1970: fiveDayWeatherData.list?[indexPath.item].dt ?? 0)
        cell.dateTimeLabel.text = formatter.string(from: date) + " h"
        
        cell.iconImageView.image = UIImage(named: fiveDayWeatherData.list?[indexPath.item].weather?.first?.icon ?? "")
        cell.temperatureLabel.text = Int(fiveDayWeatherData.list?[indexPath.item].main?.temp ?? 0).description + "°"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width - 120, height: 60)
    }
}

// MARK: UISearchBarDelegate
/*
 Возможно стоит попробовать SearchController https://developer.apple.com/documentation/uikit/uisearchcontroller.
 Анимации и состояния он возьмет на себя
 */
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
