//
//  CityDataFetch.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

class CityDataFetch : NSObject{
    
    class func get(_ fileName: String)-> [CityListModel]?{
        
        guard let jsonData = ListDataFetch.get(fileName) else{
            print("Unable to fetch data.")
            return nil
        }
        let weatherModel = try? JSONDecoder().decode([CityListModel].self, from: jsonData)
        
        return weatherModel
    }
}

// MARK: - CityListModel
struct CityListModel: Codable {
    let id: Int
    let name, state, country: String
    let coord: Coord
}
