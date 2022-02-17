//
//  WeatherTVCell.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import UIKit

class WeatherTVCell: UITableViewCell {

    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
        

    public var weather : WeatherModel!{
        didSet{
            self.lblCityName.text = weather?.name
            self.lblTemperature.text = "Temp: \(weather?.main.temp ?? 0) °C"
            self.lblDescription.text =  weather?.weather.first?.weatherDescription
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    public func setValue(_ weather : WeatherModel?){
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
