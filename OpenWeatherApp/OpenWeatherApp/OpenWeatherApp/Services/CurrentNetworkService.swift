//
//  CurrentNetworkService.swift
//  OpenWeatherApp
//
//  Created by Muhammad  Akhtar on 7/3/20.
//  Copyright © 2020 Akhtar. All rights reserved.
//

import Foundation

class CurrentNetworkService {
    static let shared = CurrentNetworkService()
    
    var allCitiesList = [LocalCityIdsElement]()
    
   let URL_CURRENT = "https://api.openweathermap.org/data/2.5/weather?q=lahore&appid=5d4ca40f008c7f9f0594ec16ed677365"
    
//http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743&units=metric&appid=5d4ca40f008c7f9f0594ec16ed677365
    
    let URL_API_KEY = "5d4ca40f008c7f9f0594ec16ed677365"
    
    var URL_GET_CURRENT = ""
    let URL_BASE = "https://api.openweathermap.org/data/2.5"
    
    let session = URLSession(configuration: .default)
    
    func buildURLWITHCity(cities:String) -> String {
        URL_GET_CURRENT = ""
        let cityCommaSeprated = "/group?id=\(cities)"
        
        URL_GET_CURRENT =  URL_BASE + cityCommaSeprated + "&units=metric&appid=" + URL_API_KEY
        print(URL_GET_CURRENT)
        return URL_GET_CURRENT
    }
    
    func getCurrentWeather(cities:String, onSuccess: @escaping (CurrentResponce) -> Void, onError: @escaping (String) -> Void) {
        guard let url = URL(string: buildURLWITHCity(cities: cities)) else {
            onError("Error building URL")
            return
        }
        
        let task = session.dataTask(with: url) { (data, response, error) in
            
            DispatchQueue.main.async {
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                
                guard let data = data, let response = response as? HTTPURLResponse else {
                    onError("Invalid data or response")
                    return
                }
                
                do {
                    if response.statusCode == 200 {
                        let items = try JSONDecoder().decode(CurrentResponce.self, from: data)
                        onSuccess(items)
                    } else {
                        onError("Response wasn't 200. It was: " + "\n\(response.statusCode)")
                    }
                } catch {
                    onError(error.localizedDescription)
                }
            }
            
        }
        task.resume()
    }
    
}
