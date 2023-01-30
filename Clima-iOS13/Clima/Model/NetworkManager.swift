//
//  NetworkManager.swift
//  Clima
//
//  Created by TharukaCs on 2022-07-17.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import Metal
import CoreLocation

protocol WeatherDelegate{
    func weatherDidUpdate(weather:Weathermodel)
    func weatherFailedToUpdate(error:Error)
}

struct NetworkManager {
    
    let BASE_URL:String = "https://api.openweathermap.org/data/2.5/weather"
    let API_KEY:String = "255485a113f73607b7d5068bc3a8c0fc"
    
    var delegate:WeatherDelegate?
    
    func fetchFromAPI(coordinates:CLLocationCoordinate2D){
        if let url = URL(string: "\(BASE_URL)?appid=\(API_KEY)&lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&units=metric"){
            call(url: url)
        }
    }
        
    func fetchFromAPI(city:String){
        if let url = URL(string: "\(BASE_URL)?appid=\(API_KEY)&q=\(city)&units=metric"){
            call(url: url)
        }
    }
    
    func call(url:URL){
        let urlSession = URLSession(configuration: .default)
        
        let task = urlSession.dataTask(with: url){ data, response, error in
            if error != nil{
                if let error = error {
                    delegate?.weatherFailedToUpdate(error: error)
                }
                return
            }
            if let safeData = data{
               if let weatherModel = self.parseJSON(data: safeData){
                    delegate?.weatherDidUpdate(weather: weatherModel)
                }
            }
        }
        
        task.resume()
    }
    
    func parseJSON(data:Data) -> Weathermodel? {
        let decoder = JSONDecoder()
            do{
                let weatherData = try decoder.decode(WeatherData.self, from: data)
                let condiation = weatherData.weather?[0].id
                let temp = weatherData.main?.temp
                let name = weatherData.name
                
                return Weathermodel(condiation: condiation ?? 0, tempreture: temp ?? 0.0, city: name)
                
            }catch{
                delegate?.weatherFailedToUpdate(error: error)
                return nil
        }
    }
    
}
