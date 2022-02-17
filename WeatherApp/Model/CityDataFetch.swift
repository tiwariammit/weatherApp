//
//  CityDataFetch.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

class CityDataFetch : NSObject{
    
    class func get(_ fileName: String, completion: @escaping (([CityListModel]?) -> Void)){
        
        guard let jsonData = ListDataFetch.get(fileName) else{
            print("Unable to fetch data.")
            return
        }
        DispatchQueue.global(qos: .background).async{
            let data = try? JSONDecoder().decode([CityListModel].self, from: jsonData)
            completion(data)
        }
    }
}

// MARK: - CityListModel
struct CityListModel: Decodable {
    let id: Int
    let name, state, country: String
    let coord: Coord
}
