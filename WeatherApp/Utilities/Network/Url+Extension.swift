//
//  Url.swift
//  News app
//
//  Created by Amrit Tiwari on 03/11/2021.
//

import Foundation

enum UrlType : String{
    
    case mock = ""
    case dev = "https://newsapi.org/v2/"
    case release = "asasas"
    case live = "http://api.openweathermap.org/data/"
//    "2.5/weather?id=4163971&appid=f788798191e2470762097c3236c979f9"
}


struct Urls {
    private static let version = "2.5"

    public static let baseUrl = UrlType.live.rawValue + version
        
    //case live = "http://api.openweathermap.org/data/2.5/weather?id=4163971&appid=f788798191e2470762097c3236c979f9"

    static func urlForWeatherAPI(byCityIDs cityIDs: String) -> String {
        return Urls.baseUrl + "/weather?id=\(cityIDs)" + "&appid=\(Constants.Keys.api)"
                   
    }
    
}


