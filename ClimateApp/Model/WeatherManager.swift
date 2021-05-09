//
//  WeatherManager.swift
//  ClimateApp
//
//  Created by MacBook Pro on 15.04.21.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherMAnager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherMAnager {
    let WeatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=5ad985551803d05645115ae461f19b92&units=metric"
    
    var delegate:  WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(WeatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(WeatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String){
            if let url = URL(string: urlString){
            let session =  URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.decipherJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func decipherJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
