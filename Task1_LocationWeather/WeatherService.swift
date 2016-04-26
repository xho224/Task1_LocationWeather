//
//  WeatherService.swift
//  Task1_LocationWeather
//
//  Created by HongXuetao on 4/23/16.
//  Copyright © 2016 Hong. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {
    func setWeather(weather: Weather)
}

class WeatherService {
    
    var delegate: WeatherServiceDelegate?
    
    func getWeather (city: String){
        //Escape New York => New%20York
        let Ecity = city.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())
        print(Ecity)
        //request weather data from api as xml form
        let path = "http://api.openweathermap.org/data/2.5/weather?q=\(Ecity!),US&mode=xml&APPID=6d55fc1f4c7786f78be2c6e34820b278"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        //assign data into variables after received xml data
        let task = session.dataTaskWithURL(url!) { (data: NSData?, responce: NSURLResponse?, error: NSError?) -> Void in
            do {
                let xmlDoc = try AEXMLDocument(xmlData: data!)
                print(xmlDoc.xmlString)
                let cname = xmlDoc.root["city"].attributes["name"]!
                var temp = Double(xmlDoc.root["temperature"].attributes["value"]!)
                let desc = xmlDoc.root["weather"].attributes["value"]!
                let ic = xmlDoc.root["weather"].attributes["icon"]!
                let la = Double(xmlDoc.root["city"]["coord"].attributes["lat"]!)
                let lo = Double(xmlDoc.root["city"]["coord"].attributes["lon"]!)
                temp = 1.8 * (temp! - 273) + 32
                let weather = Weather(cityName: cname, temp: temp!,description: desc,icon: ic, lat: la!, lon: lo!)
                if self.delegate != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                }
            }
            catch{
                print("____In dataTaskWithUrl catch error:\(error)")
            }
            
            
        }
        task.resume()
        //wait..

        
        //process data


    }
    
    func getWeather (lat: Double,lon: Double){
        
        //request weather data from api as xml form
        let path = "http://api.openweathermap.org/data/2.5/find?lat=\(lat)&lon=\(lon)&cnt=1&mode=xml&APPID=6d55fc1f4c7786f78be2c6e34820b278"
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        
        //assign data into variables after received xml data
        let task = session.dataTaskWithURL(url!) { (data: NSData?, responce: NSURLResponse?, error: NSError?) -> Void in
            do {
                let xmlDoc = try AEXMLDocument(xmlData: data!)
                //print(xmlDoc.xmlString)
                let cname = xmlDoc.root["list"]["item"]["city"].attributes["name"]!
                var temp = Double( xmlDoc.root["list"]["item"]["temperature"].attributes["value"]!)
                let desc = xmlDoc.root["list"]["item"]["weather"].attributes["value"]!
                let ic = xmlDoc.root["list"]["item"]["weather"].attributes["icon"]!
                let la = Double(xmlDoc.root["list"]["item"]["city"]["coord"].attributes["lat"]!)
                let lo = Double(xmlDoc.root["list"]["item"]["city"]["coord"].attributes["lon"]!)
                temp = 1.8 * (temp! - 273) + 32
                let weather = Weather(cityName: cname, temp: temp!,description: desc,icon: ic, lat: la!, lon: lo!)
                if self.delegate != nil{
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.delegate?.setWeather(weather)
                    })
                }
            }
            catch{
                print("\(error)")
            }
        }
        task.resume()
        //wait..
        
        
        //process data
        

    }
    
    
}