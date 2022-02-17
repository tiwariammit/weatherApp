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
    
//https://api.openweathermap.org/data/2.5/group?units=metric&APPID=fff5a7e1fd25ecd959b6f185c054a383&id=2147714,4163971,1023656,7839562,2063523,2165087,2147291
    
    static func urlForWeatherAPI(byCityIDGroup cityIDs: [Int]) -> String {

        var citiesString = ""
        for item in cityIDs{
            citiesString += String(item) + ","
        }
        citiesString.removeLast()
        return Urls.baseUrl + "/group?units=metric&APPID=\(Constants.Keys.api)" + "&id=" + citiesString
    }
    
    static func urlForWeatherAPI(byCityIDs cityIDs: String) -> String {
        return Urls.baseUrl + "/weather?id=\(cityIDs)" + "&appid=\(Constants.Keys.api)"
    }
    
}


