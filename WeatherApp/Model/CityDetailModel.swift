//
//  CityDetailModel.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 17/02/2022.
//

import Foundation

class CityDetailFetch : NSObject{
    
    class func get(_ fileName: String, completion: @escaping ((CityDetailModel?) -> Void)){
        
        guard let jsonData = ListDataFetch.get(fileName) else{
            print("Unable to fetch data.")
            return
        }
        DispatchQueue.global(qos: .background).async{
            let data = try? JSONDecoder().decode(CityDetailModel.self, from: jsonData)
            completion(data)
        }
    }
}

// MARK: - CityDetailModel
struct CityDetailModel: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
    
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}


