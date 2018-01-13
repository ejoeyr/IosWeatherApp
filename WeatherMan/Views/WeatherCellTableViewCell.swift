//
//  WeatherCellTableViewCell.swift
//  WeatherMan
//
//  Created by Joey Ramirez on 10/18/17.
//  Copyright © 2017 Joey Ramirez. All rights reserved.
//

import UIKit


class WeatherCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherLabelLabel: UILabel!
    @IBOutlet weak var tempMinLabel:UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupData(weather: CurrentWeather) -> WeatherCellTableViewCell{
        
        weatherImage.image = UIImage(named: weather.weatherType)
        dayLabel.text = weather.weatherType
            dayLabel.text = weather.cityName
        
        
        return self
    }
    
}


