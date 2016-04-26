//
//  ViewController.swift
//  Task1_LocationWeather
//
//  Created by HongXuetao on 4/23/16.
//  Copyright © 2016 Hong. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController ,CLLocationManagerDelegate, WeatherServiceDelegate{

    let weatherService = WeatherService()
    let locationManager = CLLocationManager()
    var loca: CLPlacemark!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Temp: UILabel!
    @IBOutlet weak var theCity: UITextField!
    @IBOutlet weak var mapDis: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // this is for the weather delegate
        self.weatherService.delegate = self
        //this is for the location management delegate
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //get location
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation( manager.location!, completionHandler: { (placemark, error) -> Void in
            
            if error != nil{
                print("reverseComplain print: Error is \(error)")
                return
            }
            
            if placemark!.count > 0 {
                let pm = placemark![0] as! CLPlacemark
                self.displayLocationInfo(pm)
                self.loca = pm
            }
        })
    }
    
    //Dispalylocation info on console
    func displayLocationInfo(placemark: CLPlacemark){
        //self.locationManager.stopUpdatingLocation()
        print(placemark.locality)
        print(placemark.postalCode)
        print(placemark.administrativeArea)
        print(placemark.country)
        print("the latitude is \(placemark.location?.coordinate.latitude) and the longitude is \(placemark.location?.coordinate.longitude)")
        
    }
    
    //If fail to get location information by locationManager.
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("didFail print: Error is \(error)")
    }
    
    //Display weather info on interface.
    func setWeather(weather: Weather) {
        let numberFormater = NSNumberFormatter()
        numberFormater.numberStyle = .DecimalStyle
        numberFormater.maximumFractionDigits = 1
        let f = numberFormater.stringFromNumber(weather.temp)
        
        self.Temp.text = "\(f!)°F"
        self.theCity.text = weather.cityName
        self.Description.text = weather.description
        self.weatherIcon.image = UIImage(named: weather.icon)
        
        //show location on map
        mapDis.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: weather.lat, longitude: weather.lon), span: MKCoordinateSpanMake(0.08, 0.08)), animated: true)
        let locationPinCoordinate = CLLocationCoordinate2D(latitude: weather.lat, longitude: weather.lon)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoordinate
        mapDis.addAnnotation(annotation)
        mapDis.showAnnotations([annotation], animated: true)
        
        
    }

    
    @IBOutlet weak var CityName: UITextField!
    
    @IBAction func ShowWeather(sender: UIButton) {
        var city = CityName.text
        if city != ""{
        self.weatherService.getWeather(city!)
        }
        //hide keyboard by click button
        self.CityName.resignFirstResponder()
    }
    
    @IBAction func useCurLoc(sender: UIButton) {
        self.weatherService.getWeather((loca.location?.coordinate.latitude)!, lon: (loca.location?.coordinate.longitude)!)
        //hide keyboard by click button
        self.CityName.resignFirstResponder()
        
    }
    
    //hide keyboard by click blackground
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }


}

