//
//  WeatherModel.swift
//  Clima
//
//  Created by TharukaCs on 2022-07-20.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct Weathermodel{
    let condiation:Int
    let tempreture:Double
    let city:String?
    
    var tempString:String{
        return String(format: "%.0f°", tempreture)
    }
    
    var conditionName: String {
            switch condiation {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
            }
        }
}
