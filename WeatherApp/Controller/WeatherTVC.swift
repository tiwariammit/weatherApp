//
//  ViewController.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import UIKit

class WeatherTVC: UITableViewController{

    @IBOutlet weak var btnAddCity: UIButton!
    
    private var weatherModel = WeatherDataFetch.get("weather")
    private var cityListModel : [CityListModel]?

    private var weatherCityModel : [WeatherCityModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        weatherCityModel = weatherModel?.map({ WeatherCityModel(data: $0)}) ?? []
        
       
    }

    
    @IBAction func btnAddCityTouched(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: ViewControllers.citySearchVC) as! CitySearchVC
        
        vc.cityListModel = self.cityListModel
        vc.delegate = self
//        let navVC = UINavigationController(rootViewController: vc)
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window?.layer.add(transition, forKey: kCATransition)
        
        vc.modalPresentationStyle = .overFullScreen
        
        vc.passedSelectedDataNotifier = { [weak self] data in
            guard let `self` = self else { return }
            
            let cityId = data.id
            
            let url = Urls.urlForWeatherAPI(byCityIDs: cityId.description)
                        
            print(url)
            

            ServiceManager.init(url, withParameter: nil).fetchArrayResponse(viewController: self, loadingOnView: self.view) { [weak self] (data) in
                guard let `self` = self else { return }
                
                let response = try? JSONDecoder().decode(CityDetailModel.self, from: data)
                
                guard let model = response.map({ return WeatherCityModel(data: $0)}) else {
                    return
                }
                
                self.weatherCityModel?.append(model)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } errorBlock: { error in
                
                print(error)
            }

            
//            let cityDetailFetch = CityDetailFetch.get("amrit") { data in
//
//
//                guard let model = data.map({ return WeatherCityModel(data: $0)}) else {
//                    return
//                }
//
//                self.weatherCityModel?.append(model)
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
            
//            this.weatherModel?.append(data)
//            this.tableView.reloadData()
            
        }
        
        self.present(vc, animated: false, completion: nil)
                
        print("Button Touched")
    }
}

//MARK: -TableView Datasource

extension WeatherTVC  {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherCityModel?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.weatherTVCell, for: indexPath) as! WeatherTVCell
        
        cell.weather = self.weatherCityModel?[indexPath.row]
        return cell

    }
}

//MARK: -TableView Deletage

extension WeatherTVC  {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.weatherCityModel?[indexPath.row]
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1000
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}



//MARK: -CityListDelegate

extension WeatherTVC : CityListDelegate {
    
    func getCityList(_ cityList: [CityListModel]?) {
        self.cityListModel = cityList
    }
}
