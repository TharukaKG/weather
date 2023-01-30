//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var textAreaSearch: UITextField!
    
    var networkManager:NetworkManager = NetworkManager()
    let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        textAreaSearch.delegate = self
        networkManager.delegate = self
    }
    
    @IBAction func onCLickLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextViewControllerDelegate

extension WeatherViewController: UITextFieldDelegate{
    
    @IBAction func onClickSearch(_ sender: UIButton) {
        networkManager.fetchFromAPI(city: textAreaSearch.text ?? "")
        textAreaSearch.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textAreaSearch.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        networkManager.fetchFromAPI(city: textAreaSearch.text ?? "")
        textAreaSearch.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textAreaSearch.text == ""{
            textAreaSearch.placeholder = "Type Some Thing"
            return false
        }else{
            return true
        }
    }
    
    func onReceiveWeatherData(weatherData:WeatherData){
        cityLabel.text = weatherData.name ?? "error"
    }
}

//MARK: - NetworkManagerDelegate

extension WeatherViewController: WeatherDelegate{
    
    func weatherDidUpdate(weather: Weathermodel) {
        DispatchQueue.main.async {
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.temperatureLabel.text = weather.tempString
            self.cityLabel.text = weather.city
        }
    }
    
    func weatherFailedToUpdate(error: Error) {
        print("someting went wrong:::\(error)")
    }
    
}

//MARK: - CoreLocationDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error::\(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinates = locations.first?.coordinate {
            networkManager.fetchFromAPI(coordinates: coordinates)
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            locationManager.requestLocation()
//        }
//    }
}



