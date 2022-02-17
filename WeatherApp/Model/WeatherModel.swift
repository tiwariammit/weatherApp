//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

//class WeatherDataFetch : NSObject{
//    
//    class func get(_ fileName: String)-> [WeatherModel]?{
//        
//        guard let jsonData = ListDataFetch.get(fileName) else{
//            print("Unable to fetch data.")
//            return nil
//        }
//        let data = try? JSONDecoder().decode([WeatherModel].self, from: jsonData)
//        
//        return data
//    }
//}

// MARK: - WeatherModel
struct WeatherResponse: Codable {
    let cnt: Int
    var list: [WeatherModel]
}

// MARK: - List
struct WeatherModel: Codable {
    let coord: Coord
    let sys: Syses
    let weather: [Weather]
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt, id: Int
    let name: String
  
}


// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int
    let seaLevel, grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Sys
struct Syses: Codable {
    let country: String
    let timezone, sunrise, sunset: Int
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
