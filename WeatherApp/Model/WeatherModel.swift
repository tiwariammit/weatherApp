//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation

class WeatherDataFetch : NSObject{
    
    class func get(_ fileName: String)-> [WeatherModel]?{
        
        guard let jsonData = ListDataFetch.get(fileName) else{
            print("Unable to fetch data.")
            return nil
        }
        let data = try? JSONDecoder().decode([WeatherModel].self, from: jsonData)
        
        return data
    }
}

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let city: City
    let time: Double
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let weather: [Weather]
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name, findname, country: String
    let coord: Coord
    let zoom: Int
    let langs: [Lang]?
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Lang
struct Lang: Codable {
    let de, en, fr, he: String?
    let io: String?
    let link: String?
    let nl, pl, post, pt: String?
    let ru, af, ar, bg: String?
    let ca, da, eo, es: String?
    let et, fa, fi, ga: String?
    let gd, gl, id, langIs: String?
    let it, ja, ko, lt: String?
    let nn, no, ro, sk: String?
    let sv, ta, th, ug: String?
    let zh: String?
    
    enum CodingKeys: String, CodingKey {
        case de, en, fr, he, io, link, nl, pl, post, pt, ru, af, ar, bg, ca, da, eo, es, et, fa, fi, ga, gd, gl, id
        case langIs = "is"
        case it, ja, ko, lt, nn, no, ro, sk, sv, ta, th, ug, zh
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let pressure, humidity: Int
    let tempMin, tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
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

/*
 
 
 // MARK: - WeatherModelElement
 class WeatherModelElement: Codable {
 let city: City
 let time: Int
 let main: Main
 let wind: Wind
 let clouds: Clouds
 let weather: [Weather]
 
 init(city: City, time: Int, main: Main, wind: Wind, clouds: Clouds, weather: [Weather]) {
 self.city = city
 self.time = time
 self.main = main
 self.wind = wind
 self.clouds = clouds
 self.weather = weather
 }
 }
 
 // MARK: - City
 class City: Codable {
 let id: Int
 let name, findname, country: String
 let coord: Coord
 let zoom: Int
 let langs: [Lang]?
 
 init(id: Int, name: String, findname: String, country: String, coord: Coord, zoom: Int, langs: [Lang]?) {
 self.id = id
 self.name = name
 self.findname = findname
 self.country = country
 self.coord = coord
 self.zoom = zoom
 self.langs = langs
 }
 }
 
 // MARK: - Coord
 class Coord: Codable {
 let lon, lat: Double
 
 init(lon: Double, lat: Double) {
 self.lon = lon
 self.lat = lat
 }
 }
 
 // MARK: - Lang
 class Lang: Codable {
 let de, en, fr, he: String?
 let io: String?
 let link: String?
 let nl, pl, post, pt: String?
 let ru, af, ar, bg: String?
 let ca, da, eo, es: String?
 let et, fa, fi, ga: String?
 let gd, gl, id, langIs: String?
 let it, ja, ko, lt: String?
 let nn, no, ro, sk: String?
 let sv, ta, th, ug: String?
 let zh: String?
 
 enum CodingKeys: String, CodingKey {
 case de, en, fr, he, io, link, nl, pl, post, pt, ru, af, ar, bg, ca, da, eo, es, et, fa, fi, ga, gd, gl, id
 case langIs = "is"
 case it, ja, ko, lt, nn, no, ro, sk, sv, ta, th, ug, zh
 }
 
 init(de: String?, en: String?, fr: String?, he: String?, io: String?, link: String?, nl: String?, pl: String?, post: String?, pt: String?, ru: String?, af: String?, ar: String?, bg: String?, ca: String?, da: String?, eo: String?, es: String?, et: String?, fa: String?, fi: String?, ga: String?, gd: String?, gl: String?, id: String?, langIs: String?, it: String?, ja: String?, ko: String?, lt: String?, nn: String?, no: String?, ro: String?, sk: String?, sv: String?, ta: String?, th: String?, ug: String?, zh: String?) {
 self.de = de
 self.en = en
 self.fr = fr
 self.he = he
 self.io = io
 self.link = link
 self.nl = nl
 self.pl = pl
 self.post = post
 self.pt = pt
 self.ru = ru
 self.af = af
 self.ar = ar
 self.bg = bg
 self.ca = ca
 self.da = da
 self.eo = eo
 self.es = es
 self.et = et
 self.fa = fa
 self.fi = fi
 self.ga = ga
 self.gd = gd
 self.gl = gl
 self.id = id
 self.langIs = langIs
 self.it = it
 self.ja = ja
 self.ko = ko
 self.lt = lt
 self.nn = nn
 self.no = no
 self.ro = ro
 self.sk = sk
 self.sv = sv
 self.ta = ta
 self.th = th
 self.ug = ug
 self.zh = zh
 }
 }
 
 // MARK: - Clouds
 class Clouds: Codable {
 let all: Int
 
 init(all: Int) {
 self.all = all
 }
 }
 
 // MARK: - Main
 class Main: Codable {
 let temp: Double
 let pressure, humidity: Int
 let tempMin, tempMax: Double
 
 enum CodingKeys: String, CodingKey {
 case temp, pressure, humidity
 case tempMin = "temp_min"
 case tempMax = "temp_max"
 }
 
 init(temp: Double, pressure: Int, humidity: Int, tempMin: Double, tempMax: Double) {
 self.temp = temp
 self.pressure = pressure
 self.humidity = humidity
 self.tempMin = tempMin
 self.tempMax = tempMax
 }
 }
 
 // MARK: - Weather
 class Weather: Codable {
 let id: Int
 let main, weatherDescription, icon: String
 
 enum CodingKeys: String, CodingKey {
 case id, main
 case weatherDescription = "description"
 case icon
 }
 
 init(id: Int, main: String, weatherDescription: String, icon: String) {
 self.id = id
 self.main = main
 self.weatherDescription = weatherDescription
 self.icon = icon
 }
 }
 
 // MARK: - Wind
 class Wind: Codable {
 let speed: Double
 let deg: Int
 
 init(speed: Double, deg: Int) {
 self.speed = speed
 self.deg = deg
 }
 }
 
 typealias WeatherModel = [WeatherModelElement]
 
 */
