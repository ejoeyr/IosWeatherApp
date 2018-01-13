//
//  Location.swift
//  WeatherMan
//
//  Created by Joey Ramirez on 10/22/17.
//  Copyright © 2017 Joey Ramirez. All rights reserved.
//

import Foundation
import CoreLocation

class Location{
    
   static var sharesInstance = Location()
    
    private init(){}
    
    var latitide:  Double!
    var longitude: Double!
    
    
}
