//
//  ViewController.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import UIKit

class WeatherTVC: UITableViewController{

    private var weatherModel = WeatherDataFetch.get("combineWeather")

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }
}

//MARK: -TableView Datasource

extension WeatherTVC  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.weatherTVCell, for: indexPath) as! WeatherTVCell
        
        cell.setValue(self.weatherModel?[indexPath.row])
        return cell

    }
}

//MARK: -TableView Deletage

extension WeatherTVC  {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.weatherModel?[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
