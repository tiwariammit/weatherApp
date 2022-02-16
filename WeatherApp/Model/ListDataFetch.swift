//
//  WeatherDataFetch.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

class ListDataFetch : NSObject{
    
    class func get(_ fileName: String)-> Data?{
        
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else{
            print("Invalid filename/path.")
            return nil
        }
        do {
            
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            return jsonData
            
        } catch let error {
            print("parse error: \(error.localizedDescription)")
            return nil
        }
    }
    
}
