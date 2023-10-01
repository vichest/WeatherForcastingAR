// WeatherNetworkManager.swift
// WeatherAR
//
// Created by Sanjit Pandit on 07/08/23.

import Foundation

public class WeatherNetworkManager: ObservableObject {
    @Published var receivedWeatherData: WeatherModel?
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=fcb2db63ea682dc1bbd975e8a58fed80&units=metric"
    
    // Fetch data
    public func fetchData(cityName: String) {
        let weatherURLString = "\(weatherURL)&q=\(cityName)"
        
        if let url = URL(string: weatherURLString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    fatalError(error.localizedDescription)
                }
                
                if let receivedData = data,
                   let decodedData = self.decodedJSONData(receivedData: receivedData) {
                    let weatherData = self.convertDecodedDataToUsableForm(decodedData: decodedData)
                    self.passData(weatherData: weatherData)
                }
            }
            task.resume()
        }
    }
    
    private func decodedJSONData(receivedData: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: receivedData)
            return decodedData
        } catch {
            return nil
        }
    }
    
    private func convertDecodedDataToUsableForm(decodedData: WeatherData) -> WeatherModel {
        let weatherData = WeatherModel(cityName: decodedData.name, temperature: decodedData.main.temp, conditionID: decodedData.weather[0].id)
        return weatherData
    }
    
    // Pass data
    private func passData(weatherData: WeatherModel) {
        self.receivedWeatherData = weatherData
    }
}
