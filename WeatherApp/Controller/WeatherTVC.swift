//
//  ViewController.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import UIKit

class WeatherTVC: UITableViewController{
    
    @IBOutlet weak var btnAddCity: UIButton!
    
    private var weatherModel : WeatherResponse?
    private var cityListModel : [CityListModel]?
    
    private var citiesID = [4163971, 2147714, 2174003]
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // after 80 second every time weather is refresh
        Timer.scheduledTimer(timeInterval: 80, target: self, selector: #selector(self.refreshWeather), userInfo: nil, repeats: true)
        
        self.getWeatherData(self.citiesID)
        
        // fetching citylist from json local resource
        CityDataFetch.get("cityList", completion: { [weak self] model in
            guard let `self` = self else {return}
            
            DispatchQueue.main.async {
                self.view.isUserInteractionEnabled = true
                
                self.cityListModel = model
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.btnAddCity.semanticContentAttribute = .forceRightToLeft
    }
    
    // featching the weather data from api
    private func getWeatherData(_ cities : [Int]){
        
        let url = Urls.urlForWeatherAPI(byCityIDGroup: cities)
        print(url)
        ServiceManager.init(url, withParameter: nil).fetchArrayResponse(viewController: self, loadingOnView: self.view) { [weak self] response in
            guard let `self` = self else { return }
            
            let responseModel = try? JSONDecoder().decode(WeatherResponse.self, from: response)
            self.weatherModel = responseModel
            
            self.tableView.reload(.roll, animationType: .curveEaseInOut, withTableViewHidden: true, andAnimationTime: 2, usingSpringWithDamping: 0.9)
            
        } errorBlock: { error in
            
        }
    }
    
    // after 80 second every time weather is refresh
    @objc func refreshWeather()
    {
        self.getWeatherData(self.citiesID)
    }
    
    @IBAction func btnAddCityTouched(_ sender: UIButton) {
        
        self.btnAddCity.semanticContentAttribute = .forceRightToLeft

        guard let cityListModel = self.cityListModel else {
            self.presentErrorDialog("Fetching the city data please wait for a while.")
            return
        }
        
        let vc : CitySearchVC = self.storyboard!.instantiateViewController()
        
        vc.cityListModel = cityListModel
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window?.layer.add(transition, forKey: kCATransition)
        
        vc.modalPresentationStyle = .overFullScreen
        
        // get the selected cities details
        vc.passedSelectedDataNotifier = { [weak self] data in
            guard let `self` = self else { return }
            
            let cityId = [data.id]
            
            self.citiesID.append(data.id)
            
            let url = Urls.urlForWeatherAPI(byCityIDGroup: cityId)
            
            print(url)
            // get weather data for selected cities
            ServiceManager.init(url, withParameter: nil).fetchArrayResponse(viewController: self, loadingOnView: self.view) { [weak self] (data) in
                guard let `self` = self else { return }
                
                let response = try? JSONDecoder().decode(WeatherResponse.self, from: data)
                let list = response?.list ?? []
                
                self.weatherModel?.list.append(contentsOf: list)
                DispatchQueue.main.async {
                    self.tableView.reload()
                }
                
            } errorBlock: { error in
                
                print(error)
            }
        }
        
        self.present(vc, animated: false, completion: nil)
    }
}

//MARK: -TableView Datasource

extension WeatherTVC  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherModel?.list.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : WeatherTVCell = tableView.dequeueReusableCell(for: indexPath)
        
        cell.weather = self.weatherModel?.list[indexPath.row]
        return cell
        
    }
}

//MARK: -TableView Deletage

extension WeatherTVC  {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc : WeatherDetailVC = self.storyboard!.instantiateViewController()
        // pass the weather detail toWeatherDetailView
        let data = self.weatherModel?.list[indexPath.row]
        vc.weatherModel = data
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

