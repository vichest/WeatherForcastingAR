//
//  WeatherData.swift
//  WeatherAR
//
//  Created by Sanjit Pandit on 07/08/23.
//

import Foundation
struct WeatherData: Codable{
    let name:String
    let main: Main
    let weather:[Weather]
}
struct Weather:Codable{
    let id:Int
}
struct Main:Codable{
    let temp:Double
}
