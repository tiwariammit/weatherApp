//
//  CitySearchTVCell.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import Foundation
import UIKit

class CitySearchTVCell: UITableViewCell {
    
    @IBOutlet weak var lblCityName: UILabel!//14
    
    public var cityDetail : CityListModel!{
        didSet{
            
            self.lblCityName.text = cityDetail.name
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.lblMovieName.textColor = .text
    }
    
    
  
    
}
