//
//  ViewController.swift
//  Weather App
//
//  Created by Alejandro Hernández Cortés on 28/09/20.
//  Copyright © 2020 Alejandro Hernández Cortés. All rights reserved.
//

import UIKit
import CoreLocation

class MainVC: UIViewController{
  
  
    @IBOutlet weak var textFld: UITextField!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var weather = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        weather.delegate = self
        textFld.delegate = self
        setup()
        checkHourForBgImage()
        hideKeyboardWhenTappedAround()
        
    }
    
    func setup(){
        textFld.textAlignment = .center
         textFld.backgroundColor = .lightGray
        textFld.alpha = 0.3
        textFld.layer.cornerRadius = textFld.frame.height/2
        textFld.layer.masksToBounds = true
        textFld.attributedPlaceholder = NSAttributedString(string: "Search by city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Avenir", size: 24)!])
    }
    
    func checkHourForBgImage() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        let hourString = formatter.string(from: date)
        if hourString >= "20:00 PM" {
            backgroundImage.image = UIImage(named: "night")
        }
        else {
            backgroundImage.image = UIImage(named: "day")
        }
    }
    
    
    
   
   
    
}

//MARK: - CLLocationManagerDelegate

extension MainVC: CLLocationManagerDelegate {
    
    @IBAction func weatherButtonPressed(_ sender: UIButton){
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weather.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

//MARK: - MainVC extension
extension MainVC: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm a"
            let stringHour = formatter.string(from: date)
            if stringHour >= "20:00 PM" {
                self.icon.image = UIImage(systemName: "moon")
            }else{
                self.icon.image = UIImage(systemName: weather.conditionName)
            }
            self.cityName.text = weather.cityName
            //self.icon.image = UIImage(systemName: weather.conditionName)
            self.tempLabel.text = weather.temperatureString
        }
        
      }
    func didFailWithError(error: Error) {
        print(error)
    }
    
   
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(MainVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}

//MARK: - UITextFieldDelegate

extension MainVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textFld.text {
            weather.fetchWeather(cityName: city)
        }
        textFld.text = ""
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
}

