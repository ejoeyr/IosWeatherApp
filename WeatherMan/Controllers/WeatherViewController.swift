//
//  ViewController.swift
//  WeatherMan
//
//  Created by Joey Ramirez on 10/16/17.
//  Copyright © 2017 Joey Ramirez. All rights reserved.
//

//Import packages/modules
import UIKit
import Alamofire
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weatherTempLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentWeatherImageView: UIImageView!
    
    private var weatherDataArray = [String]()
    private var currentWeather = CurrentWeather()
    private var forecastArray = [CurrentWeather]()
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager.delegate  = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        
        //set the delegate and datasource to self or this class
        tableView.delegate = self
        tableView.dataSource = self
        //remove separation
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationAuthStatus()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherCellTableViewCell {
            
            return cell.setupData(weather: forecastArray[indexPath.row])
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //TODO SHOW SOMETHING ON TAP
        
    }
    
    
    func updateUI(){
        
        self.weatherTempLabel.text = String(currentWeather.weatherTemp)
        self.locationLabel.text =  currentWeather.cityName
        self.dateLabel.text = currentWeather.weatherDate
        self.currentWeatherImageView.image = UIImage(named: currentWeather.weatherType)
    }
    
    
    func requestCurrentWeatherData(){
        
        currentWeather.requestWeatherData(latitude:  Location.sharesInstance.latitide,
                                          longitude: Location.sharesInstance.longitude){
                                            
            self.updateUI()
        }
        
    }
    
    func locationAuthStatus()  {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            
            currentLocation = locationManager.location
            
            Location.sharesInstance.latitide = currentLocation.coordinate.latitude
            Location.sharesInstance.longitude = currentLocation.coordinate.longitude
            
            requestCurrentWeatherData()
            
            requestFiveDayForecast()
            
        }else{
            locationManager.requestWhenInUseAuthorization()
            
            locationAuthStatus()
        }
    }
    
    func requestFiveDayForecast(){
        
        let requestURL =  "\(API_BASE_URL_FORECAST)\(API_KEY)&\(API_PARAM_LATITUDE)\(  Location.sharesInstance.latitide!)&\(API_PARAM_LONGITUDE )\(Location.sharesInstance.longitude!)"
        
        print(requestURL)
        
        Alamofire.request(requestURL, method: .get).responseJSON(){ response in
            
            if let jsonResponse = response.result.value as? Dictionary<String,AnyObject>{
                
                if let list = jsonResponse["list"] as? [Dictionary<String,AnyObject>]{
                    
                    self.forecastArray.removeAll()
                    
                    for i in 0..<list.count{
                        
                        var weatherData = CurrentWeather()
                        
                        //get the list item
                        if let listItem = list[i] as? Dictionary<String,AnyObject>{
                            
                            if let main = listItem["main"] as? Dictionary<String,AnyObject>{
                                
                                if let temp = main["temp"] as?  Double{
                                    weatherData._weatherTemp = temp
                                }
                                
                            }
                            
                            if let weather = listItem["weather"] as? [Dictionary<String,AnyObject>] {
                                
                                if let main = weather[0]["main"] as? String{
                                    weatherData._weatherType = main
                                }
                                
                                if let cityName = weather[0]["description"] as? String{
                                    weatherData._cityName = cityName
                                }
                            }
                        }
                        
                        self.forecastArray.append(weatherData)
                    }
                    
                }
                
            }
            
            self.tableView.reloadData()
        }
        
    }
    
    
}

