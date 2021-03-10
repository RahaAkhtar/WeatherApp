//
//  ViewController.swift
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/3/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var weatherResult: CurrentResponce? {
        didSet {
            self.tableView.dataSource = self
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var citiesTextField: UITextField!
    @IBOutlet weak var getCitiesUpdateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        CommonFunctions.parsCityIDsJsson()
        self.tableView.isHidden = true
        self.getCitiesUpdateButton.isEnabled = true
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func getWeather(citiesId:String) {
        
        CurrentNetworkService.shared.getCurrentWeather(cities:citiesId, onSuccess: { (result) in
            self.weatherResult = result
        }) { (errorMessage) in
            debugPrint(errorMessage)
        }
    }

    @IBAction func getCitiesIdTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            if CurrentNetworkService.shared.allCitiesList.count > 0 {
                guard let citiesListCommaSeprated = self.citiesTextField.text else {
                    return
                }
                
                let citiesList = citiesListCommaSeprated.components(separatedBy: ",")
                if citiesList.count > 2 && citiesList.count < 7 {
                    let cityId = CommonFunctions.getCityIdBy(citiesName: citiesList)
                    
                    if CommonFunctions.isConnectedToNetwork() {
                        getWeather(citiesId: cityId)
                    } else {
                        CommonFunctions.showAlertControllerWith(title: "Internet Error", message: "Please Check you network and try again.", onVc: self, buttons: ["OK"]) { (succes, index) in
                            if index == 0 { //

                            }
                        }
                    }
                } else {
                    CommonFunctions.showAlertControllerWith(title: "Error", message: "Please enter min 3 and max 7 cities (comma Separated)", onVc: self, buttons: ["OK"]) { (succes, index) in
                        if index == 0 { //

                        }
                    }
                }
                
            }
        } else {
            self.performSegue(withIdentifier: "ForecastView", sender: self)
        }
        
    }
    
    //MARK: -- UITableViewDataSource --
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        (self.weatherResult?.list.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherCell", for: indexPath) as! CurrentWeatherCell
        cell.configureCell(cityWeather: (self.weatherResult?.list[indexPath.row])!)
           return cell
    }
    
     //MARK: -- UITextfield delegate --
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty{
            self.getCitiesUpdateButton.isEnabled = false
        } else {
             self.getCitiesUpdateButton.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " " {
            return false
        }
        return true
    }
}

