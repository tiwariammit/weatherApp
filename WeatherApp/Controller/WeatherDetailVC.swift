//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 17/02/2022.
//

import UIKit

class WeatherDetailVC: UIViewController {

    
    @IBOutlet weak var lblWeatherDescription: UILabel!
    @IBOutlet weak var lblMinTemp: UILabel!
    @IBOutlet weak var lblMaxTemp: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!

    public var weatherModel: WeatherModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setValue(self.weatherModel)
    }
    

    private func setValue(_ weather : WeatherModel?){
        
        self.title = weather?.name

        self.lblWeatherDescription.text = "Today weather is " + (weather?.weather.first?.weatherDescription ?? "")
        
        self.lblMinTemp.text = "Minimum Temp: \(weather?.main.tempMin ?? 0) °C"
        self.lblMaxTemp.text = "Maximum Temp: \(weather?.main.tempMax ?? 0) °C"
        self.lblHumidity.text = "Humidity: \(weather?.main.humidity ?? 0)%"
        
    }

}
