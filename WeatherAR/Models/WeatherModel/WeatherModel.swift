//
//  WeatherModel.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 08/08/23.
//

import Foundation
struct WeatherModel{
    let cityName:String
    let temperature:Double
    let conditionID: Int
    var conditionName:String{
        switch conditionID{
        case 200...232:
            return "thunder"
        case 300...321:
            return "rainy"
        case 500...531:
            return "rainy"
        case 600...622:
            return "snow"
        case 701...781:
            return "fog"
        case 800:
            return "sunny"
        case 801...804:
            return "normal"
        default:
            return "normal"
        }
    }
}
