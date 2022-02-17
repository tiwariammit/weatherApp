//
//  CitySearchVC.swift
//  WeatherApp
//
//  Created by Amrit Tiwari on 16/02/2022.
//

import UIKit

class CitySearchVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customNavBar: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tableViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchTextField: ATTextField!
    
    let rowheight : CGFloat = 50
    
    fileprivate let footerHeight : CGFloat = 50
    fileprivate var keyBoardHeight : CGFloat = 200
    
    public var passedSelectedDataNotifier : ((CityListModel)->())? // use to pass seleted data fom search
    
    public var cityListModel : [CityListModel]?
    
    private var searchCityList : [CityListModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.isOpaque = false
        
        self.searchTextField.placeHolderColor = .white
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChanged(_:)), for: .editingChanged)
        self.searchTextField.clearButtonColor = .white
        self.tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.searchTextField.becomeFirstResponder()
        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(keyboardWillDisappear(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    
    @objc fileprivate func textFieldDidChanged(_ textField: ATTextField){
        
        self.searchCityList.removeAll()
        
        self.tableView.reloadData()
        
        guard let searchText = textField.text?.trim(), searchText.count > 0 else{
            return
        }
        
        let predicate = NSPredicate(format: "SELF contains [c] %@", searchText)
        self.searchCityList = self.cityListModel?.filter { predicate.evaluate(with: $0.name) } ?? []
        
        self.tableView.reloadData()
    }
    
    deinit {
        print("SearchVC Deinitiallized")
    }
    
    @objc func keyboardWillAppear(notification: NSNotification?) {
        
        guard let keyboardFrame = notification?.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        //        if #available(iOS 11.0, *) {
        //            keyBoardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        //        } else {
        keyBoardHeight = keyboardFrame.cgRectValue.height
        self.tableView.reloadData()
        //        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        self.keyBoardHeight = 0
        self.tableView.reloadData()
    }
    
    private func dismissController(){
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        view.window?.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnBackTouched(_ sender: Any) {
        
        self.dismissController()
    }
}


//MARK:- Table view datasource and delegate
extension  CitySearchVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // calculating the height keyboard and managed table view height
        let count = self.searchCityList.count
        let height = CGFloat(CGFloat(count)*self.rowheight) + self.footerHeight
        var bottomSafeAreaHeight :CGFloat = 0
        
        if #available(iOS 11.0, *) {
            bottomSafeAreaHeight =  self.view.safeAreaInsets.bottom
        }
        
        let maxHeight = self.view.frame.height - self.customNavBar.frame.height - self.keyBoardHeight - bottomSafeAreaHeight
        
        self.tableViewHeightConstraints.constant = maxHeight>height ? height : maxHeight
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.citySearchTVCell, for: indexPath) as! CitySearchTVCell
        
        cell.cityDetail = self.searchCityList[indexPath.row]
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityDetail = self.searchCityList[indexPath.row]
        
        self.passedSelectedDataNotifier?(cityDetail)
        self.dismissController()
        
    }
}
