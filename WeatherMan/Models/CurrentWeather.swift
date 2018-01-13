
//  CurrentWeather.swift
//  WeatherMan
//
//  Created by Joey Ramirez on 10/21/17.
//  Copyright © 2017 Joey Ramirez. All rights reserved.
//

import Foundation
import Alamofire

class CurrentWeather{
    
    
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _weatherTemp: Double!
    
    
    var cityName: String{
        if _cityName == nil{
            _cityName =  ""
        }
        return _cityName
    }
    
    var weatherType: String{
        if _weatherType == nil{
            _weatherType = ""
        }
        return _weatherType
    }
    
    var weatherTemp: Double{
        
        if _weatherTemp == nil{
            _weatherTemp = 0.0
        }
        return _weatherTemp
    }
    
    var weatherDate: String{
        if _date == nil{
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate  = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return self._date
    }
    
    func requestWeatherData(latitude: Double, longitude: Double, completed: @escaping DownloadComplete) {
        let requestURL =  "\(API_BASE_URL_CURRENT)\(API_KEY)&\(API_PARAM_LATITUDE)\(  latitude)&\(API_PARAM_LONGITUDE )\(longitude)"
        
        //Setting up params
        var params = Parameters()
        params["appid"] = API_KEY
        params["lat"] = latitude
        params["lon"] = longitude
        
        //print request url
        print(requestURL)
        
        Alamofire.request(requestURL, method: .get).responseJSON{ response in
            
            //get the response's value and cast as dictionary type of string and anyobject
            if let dict = response.result.value as? Dictionary<String,AnyObject>{
                
                if let cityName = dict["name"] as? String{
                    self._cityName = cityName.capitalized
                }
                
                if let weatherDetails = dict["weather"] as? [Dictionary<String,AnyObject>]{
                    if let main = weatherDetails[0]["main"] as? String{
                        self._weatherType = main.capitalized
                    }
                }
                
                if let main  = dict["main"] as? Dictionary<String,AnyObject>{
                    
                    if let temperature  = main["temp"] as? Double{
                        self._weatherTemp = temperature
                    }
                    
                }
                
            }
            
            //callback trigger that processes are finished
            completed()
            
        }
        
    }
    
    
}







