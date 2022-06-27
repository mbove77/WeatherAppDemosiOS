//
//  WeatherManager.swift
//  WheatherTest
//
//  Created by Resonant Sports on 09/12/2021.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getCurrentWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees) async throws -> ResponseBody {
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=YOUR_APPID_HERE&units=metric") else { fatalError("Missing URL.")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data.")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            
        return decodedData
    }
    
    func getIcon(iconID: String) -> URL? {
        let baseURL = "https://openweathermap.org/img/wn/"
        return URL(string: baseURL + iconID + "@2x.png")
    }
    
    
    func isSunSet(sunSetTime: Double) -> Bool {
        let dateSunSet = Date(timeIntervalSince1970: sunSetTime)
        let dateNow = Date()
    
        let timeDateFormatter = DateFormatter()
        timeDateFormatter.dateFormat = "HH:mm"
        
        let HHmmSunSet = timeDateFormatter.string(from: dateSunSet)
        let HHmmNow = timeDateFormatter.string(from: dateNow)
        
        print("Night time is \(HHmmSunSet)")
        
        if(HHmmNow >= HHmmSunSet) {
            print("is night")
            print("=============================")
            return true
        } else {
            print("is day")
            print("=============================")
            return false
        }
    }
    
//  TODO ver como hacer que la url cambie cuando se actualiza el clima.
    func getDayOrNightBackground(sunSetTime: Double) -> URL? {
        let dayUrl = URL(string: "https://cdn.pixabay.com/photo/2016/11/21/03/56/landscape-1844230_960_720.png")
        let nightUrl = URL(string: "https://cdn.pixabay.com/photo/2016/11/21/03/56/landscape-1844231_1280.png")
        
        if isSunSet(sunSetTime: sunSetTime) {
            return nightUrl
        } else {
            return dayUrl
        }
        
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    var sys: SysResponse
    var timezone: Double
   

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
    
    struct SysResponse: Decodable {
        var sunrise: Double
        var sunset: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
