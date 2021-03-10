//
//  CommonFunctions.swift
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/3/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

import UIKit

import UIKit

open class CommonFunctions: NSObject {
    
    static func parsCityIDsJsson(){
        if let path = Bundle.main.path(forResource: "city_list", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  //let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let cityListWithID = try! JSONDecoder().decode(LocalCityIdsModel.self, from: data)
                CurrentNetworkService.shared.allCitiesList = cityListWithID
                
//                  if let jsonResult = jsonResult as? [Any] {
//                            // do stuff
//                    //print(jsonResult)
//                  }
                
              } catch {
                   // handle error
              }
        }
    }
    
    static func getCityIdBy(citiesName: [String]) -> String {
        
        var cityId = ""
        for city in citiesName {
            if let object = CurrentNetworkService.shared.allCitiesList.filter({ $0.name == city }).first {
                if cityId.isEmpty {
                    cityId = "\(object.id)"
                } else {
                    cityId = cityId + ",\(object.id)"
                }
                
            } else {
                print("not found")
            }
        }
        
        return cityId
    }
    
    class func showAlertControllerWith(title:String, message:String?, onVc:UIViewController , style: UIAlertController.Style = .alert, buttons:[String], completion:((Bool,Int)->Void)?) -> Void {

        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: style)
        for (index,title) in buttons.enumerated() {
            let action = UIAlertAction.init(title: title, style: UIAlertAction.Style.default) { (action) in
                completion?(true,index)
            }
            alertController.addAction(action)
        }

        onVc.present(alertController, animated: true, completion: nil)
    }
    
    static func isConnectedToNetwork() -> Bool {
        
        
        let status = Reach().connectionStatus()
        switch status {
        case .unknown, .offline:
            //print("Not connected")
            return false
        case .online(.wwan):
            //print("Connected via WWAN")
            return true
        case .online(.wiFi):
            //print("Connected via WiFi")
            return true
        }
    }
    
}
