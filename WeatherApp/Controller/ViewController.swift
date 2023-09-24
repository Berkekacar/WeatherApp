//
//  ViewController.swift
//  WeatherApp
//
//  Created by Berke Kaçar on 21.09.2023.
//

import UIKit
import CoreLocation
import Foundation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    var currentLocation = ""
    var locationManager = CLLocationManager()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUI()
        
       
        
        
        
        
    }
    
    func setUI() {
           configureLocationManager()
       }
       
       func configureLocationManager() {
           locationManager.delegate = self
           
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestWhenInUseAuthorization()
           locationManager.startUpdatingLocation()
       }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let geocoder = CLGeocoder()
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Hata oluştu: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    if let city = placemark.locality {
                        self.locationLabel.text = "\(city)"
                        
                        self.weatherApi(city: city)
                    }
                    
                }
                
            }
            locationManager.stopUpdatingLocation()
        }
    }
    
    func weatherApi(city: String){
        let modifiedCity = city.replacingOccurrences(of: " ", with: "+")
        
        let apiUrl = URL(string:"http://api.weatherstack.com/current?access_key=bab52eb5920d5c65e0a75a618dbcef72&query=\(modifiedCity)")!
        
        let session = URLSession.shared
        
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request){
            (data,res,err) in
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        if let location = json["location"] as? [String: Any] {
                            // "location" altındaki verilere erişebilirsiniz.
                            if let country = location["country"] as? String {
                                print("Ülke: \(country)")
                            }
                            if let lat = location["lat"] as? String {
                                print("Enlem: \(lat)")
                            }
                            if let lon = location["lon"] as? String {
                                print("Boylam: \(lon)")
                            }
                            // Diğer location altındaki verilere de benzer şekilde erişebilirsiniz.
                            
                        }}} catch {
                    
                }
            }
        }
        task.resume()
    }
    
    

}

