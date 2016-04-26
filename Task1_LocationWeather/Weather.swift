//
//  Weather.swift
//  Task1_LocationWeather
//
//  Created by HongXuetao on 4/24/16.
//  Copyright © 2016 Hong. All rights reserved.
//

import Foundation

struct Weather {
    let cityName: String
    let temp:Double
    let description:String
    let icon: String
    let lat: Double
    let lon: Double
    
    init(cityName: String, temp: Double, description: String, icon: String, lat: Double, lon: Double){
        self.cityName = cityName
        self.temp = temp
        self.description = description
        self.icon = icon
        self.lat = lat
        self.lon = lon
    }
}