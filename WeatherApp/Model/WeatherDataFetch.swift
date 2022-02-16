//
//  WeatherDataFetch.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

class WeatherDataFetch : NSObject{
    
    class func get(_ fileName: String)-> [WeatherModel]?{
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else{
            print("Invalid filename/path.")
            return nil
        }
        do {
            
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let weatherModel = try? JSONDecoder().decode([WeatherModel].self, from: jsonData)
            
            return weatherModel
            
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
