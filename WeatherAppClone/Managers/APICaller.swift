//
//  APICaller.swift
//  WeatherAppClone
//
//  Created by John Gamil on 14/06/2023.
//

import Foundation

struct constants {
    static let api_key = "46b3595dcfab359449c0d583c9fad1cf"
    static let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
}
class APICaller{
    static let shared = APICaller()
    func fetchHourlyWeatherData(for city: String, completion: @escaping ([Weather]?, Error?) -> Void) {
        let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = "46b3595dcfab359449c0d583c9fad1cf"
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            let error = NSError(domain: "com.example.weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(nil, error)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                let error = NSError(domain: "com.example.weatherapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Data not found"])
                completion(nil, error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                if let weatherList = json["list"] as? [[String: Any]] {
                    let dateFormatter = DateFormatter()
                    var weatherData: [Weather] = []
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    for i in 0..<5 {
                            let dateString = weatherList[i]["dt_txt"] as! String
                            let date = dateFormatter.date(from: dateString)!
                            let timeFormatter = DateFormatter()
                            timeFormatter.dateFormat = "h:mm a"
                            let timeString = timeFormatter.string(from: date)
                                        
                            let main = weatherList[i]["main"] as! [String: Any]
                            let temp = main["temp"] as! Double
                            let humidity = main["humidity"] as! Int
                                        
                            let wind = weatherList[i]["wind"] as! [String: Any]
                            let windSpeed = wind["speed"] as! Double
                                        
                            let weatherInfo = weatherList[i]["weather"] as! [[String: Any]]
                            let weatherCondition = weatherInfo[0]["description"] as! String
                                        
                            let weather = Weather(date: timeString, temp: temp, humidity: humidity, windSpeed: windSpeed, weatherCondition: weatherCondition)
                        weatherData.append(weather)
                    }
                    
                    completion(weatherData, nil)
                }
            } catch let error as NSError {
                completion(nil, error)
            }
        }
        
        task.resume()
    }
    func fetchDailyWeatherData(for city: String, completion: @escaping ([Weather]?, Error?) -> Void) {
        let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
        let apiKey = "46b3595dcfab359449c0d583c9fad1cf"
        let urlString = "\(baseUrl)?q=\(city)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "com.example.weatherapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "com.example.weatherapp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Data not found"]))
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                guard let weatherList = json["list"] as? [[String: Any]] else {
                    completion(nil, NSError(domain: "com.example.weatherapp", code: 3, userInfo: [NSLocalizedDescriptionKey: "Weather data not found"]))
                    return
                }
                var weatherData: [Weather] = []
                var dates: Set<String> = []
                for weatherItem in weatherList {
                    let dateText = weatherItem["dt_txt"] as! String
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date = dateFormatter.date(from: dateText)!
                    let calendar = Calendar.current
                    let day = calendar.component(.day, from: date)
                    let month = calendar.component(.month, from: date)
                    let year = calendar.component(.year, from: date)
                    let dateString = "\(day).\(month).\(year)"
                    if dates.insert(dateString).inserted {
                        let main = weatherItem["main"] as! [String: Any]
                        let temp = main["temp"] as! Double
                        let humidity = main["humidity"] as! Int
                        let weatherInfo = weatherItem["weather"] as! [[String: Any]]
                        let weatherCondition = weatherInfo[0]["description"] as! String
                        let weather = Weather(date: dateString, temp: temp, humidity: humidity, windSpeed: 0, weatherCondition: weatherCondition)
                        weatherData.append(weather)
                    }
                    if weatherData.count == 5 {
                        break
                    }
                }
                
                completion(weatherData, nil)
            } catch let error as NSError {
                completion(nil, error)
            }
        }
        
        task.resume()
        }
    }

