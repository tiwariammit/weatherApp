//
//  Service.swift
//  News app
//
//  Created by Amrit Tiwari on 06/02/2022.
//

import Foundation
import UIKit

enum HttpMethod : String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
}

struct StatusCode {
    
    static let success : Int = 200
    static let signUpSuccess : Int = 201 // success on sign up
}

protocol ServiceProtocol {
    func getSuccessData( _ successData : Data, withResponseTag tag : Int)
    func getErrorData(_ errorData : Data)
    func getFailureBlock (_ failureMessage : String)

}

extension ServiceProtocol{
    func getErrorData(_ errorData : Data) {}
    func getFailureBlock (_ failureMessage : String){}
    func getSuccessData( _ successData : Data, withResponseTag tag : Int){}
}

class ServiceManager: NSObject {
    
    var request : URLRequest!
    
    public var serviceProtocol : ServiceProtocol?
    
    public init(_ url : String, withParameter parameter : [String: AnyObject]?, headers: [String: String] = [String:String](), method: HttpMethod = .get, isKillAllSession: Bool = false){
        
        self.request = URLRequest(url: URL(string:url)!)
        
        for (key, value) in headers{
            request.addValue(key, forHTTPHeaderField: value)
        }
        
        request.httpMethod = method.rawValue
        
        if let params = parameter{
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        }
    }
    
    
    func fetchArrayResponse(viewController: UIViewController, loadingOnView view: UIView, withLoadingColor actColor : UIColor = UIColor(red: 0.941, green: 0.941, blue: 0.941, alpha: 1.00), isShowProgressHud: Bool = true,isShowNoNetBanner: Bool = true, isShowAlertBanner: Bool = true, successTag tag : Int){
        
        var style = ToastManager.shared.style
        style.backgroundColor = .toastError
        style.cornerRadius = 0
        
        // show alert for no net
        do {
            let googleTest = try Reachability(hostname: "www.google.com")
            
            guard let result = googleTest?.isReachable, result else {
                
                let errorMessage = Errors.Apis.noInternet
                self.serviceProtocol?.getFailureBlock(errorMessage)
                
                if isShowNoNetBanner{
                    delay(delay: 2) {
                        viewController.presentErrorDialog(errorMessage)
                    }
                }
                return
            }
            
        } catch {
            print(error)
        }
        
        
        let loadingView = LoadingView.init()//get()
        
        if isShowProgressHud {
            
            view.isUserInteractionEnabled = false
            loadingView.set(withLoadingView: view, withBackgroundColor: .loadingWhite, withLoadingIndicatorColor: .app)
            //            view.addSubview(loadingView)
        }
        
        
        let sessionTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
            
                if isShowProgressHud{
                    DispatchQueue.main.async {
                        view.isUserInteractionEnabled = true
                        loadingView.remove()
                    }
                }
                
                if let err = error {
                    print("Failed to fetch courses:", err)
                    
                    if isShowAlertBanner {
                        viewController.presentErrorDialog(err.localizedDescription)
                    }
                    self.serviceProtocol?.getFailureBlock(err.localizedDescription)
                    return
                }
                
                guard let data = data else{
                    
                    let errorMessage = error?.localizedDescription ?? "Failed to fetch courses"
                    if isShowAlertBanner {
                        viewController.presentErrorDialog(errorMessage)
                    }
                    
                    self.serviceProtocol?.getFailureBlock(errorMessage)

                    return
                }
                
                //for printing response
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch {
                    print(error)
                }
                //
                
                let httpResponse = response as! HTTPURLResponse
                let statusCode = httpResponse.statusCode
                
                if statusCode == StatusCode.success || statusCode == StatusCode.signUpSuccess{
                    
                    self.serviceProtocol?.getSuccessData(data, withResponseTag: tag)
                    return
                }
                
                if isShowAlertBanner {
                    do{
                        let response = try JSONDecoder().decode(ErrorResponse.self, from: data)
                        viewController.presentErrorDialog(response.message)
                        self.serviceProtocol?.getFailureBlock(response.message)
                        return

                    }catch{
                        print(error)
                    }
                }
                self.serviceProtocol?.getErrorData(data)
                return

            }
        }
        sessionTask.resume()
    }
}

struct ErrorResponse : Codable{
    var message : String
}
