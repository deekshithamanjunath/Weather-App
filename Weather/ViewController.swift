//
//  ViewController.swift
//  Weather
//
//  Created by Venkateshprasad Ashwathnarayana on 12/15/16.
//  Copyright © 2016 Venkateshprasad Ashwathnarayana. All rights reserved.
//

import UIKit
import CoreLocation
import WeatherGetter




fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool
{
    switch (lhs, rhs)
    {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}


class ViewController: UIViewController,WeatherDelegate,CLLocationManagerDelegate,UITextFieldDelegate
{
    
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var getCityWeatherButton: UIButton!
    @IBOutlet var getCurrentLocationWeatherButton: UIButton!
    @IBOutlet var tempCLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var weatherIcon: UIImageView!
    
    let location1 = CLLocationManager()
    var weather: WeatherGetter!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        weather = WeatherGetter(delegate: self)
        cityTextField.delegate = self
        cityTextField.enablesReturnKeyAutomatically = true
        getCityWeatherButton.isEnabled = false
        fetchLoaction()
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value,forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
        
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func infoButtonPressed() {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "InfoView") as! InfoViewController
        
        secondViewController.myStringValue = cityLabel.text!
        
    }
    
    
    @IBAction func setAsCurCityTapped() {
        let defaults = UserDefaults(suiteName: "group.weatherapp.cityname")
        defaults?.set(self.cityLabel.text?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!, forKey: "cityname")
        defaults?.synchronize()
        
    }
    
    @IBAction func getWeatherForLocationTapped(_ sender: UIButton) {
        getCurrentLocationWeatherButton.isEnabled = false
        getCityWeatherButton.isEnabled = false
        fetchLoaction()
        cityTextField.text = ""
    }

    @IBAction func getWeatherForCityTapped(_ sender: UIButton) {
        guard (cityTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty) != nil else
        {
            return
        }
        getCurrentLocationWeatherButton.isEnabled = false
        getCityWeatherButton.isEnabled = false
        view.endEditing(true)
        weather.getWeatherByCity(cityTextField.text!.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!)
        cityTextField.text = ""
    }
    
    
    
    func weatherGetSuccess(_ weather: Weather)
    {
        DispatchQueue.main.async
            {
                self.cityLabel.text = weather.city
                let desc:String = weather.weatherDescription
                self.weatherLabel.text = desc.capitalized
                self.tempCLabel.text = "\(weather.tempCelsius)°C"
                self.tempLabel.text = "\(Int(round(weather.tempFahrenheit)))°F"
                
                if case weather.mainWeather = "Clouds"
                {
                    self.image.image = UIImage(named: "cloud")
                }
                else if case weather.mainWeather = "Rain"
                {
                    self.image.image = UIImage(named: "rain")
                }
                else if case weather.mainWeather = "Drizzle"
                {
                    self.image.image = UIImage(named: "rain")
                }
                else if case weather.mainWeather = "Thunderstorm"
                {
                    self.image.image = UIImage(named: "rain")
                }
                else if case weather.mainWeather = "Fog"
                {
                    self.image.image = UIImage(named: "fog")
                }
                else if case weather.mainWeather = "Mist"
                {
                    self.image.image = UIImage(named: "fog")
                }
                else if case weather.mainWeather = "Haze"
                {
                    self.image.image = UIImage(named: "haze")
                }
                else if case weather.mainWeather = "Snow"
                {
                    self.image.image = UIImage(named: "snow")
                }
                else
                {
                    self.image.image = UIImage(named: "day")
                }
                self.getCurrentLocationWeatherButton.isEnabled = true
                self.getCityWeatherButton.isEnabled = self.cityTextField.text?.characters.count > 0
        
                
        }
    }
    
    
    func weatherGetFail(_ error: NSError)
    {
        DispatchQueue.main.async
            {
                let alert = UIAlertController(title: "Unable to fetch weather",message: "Open weather map API is not available",preferredStyle: .alert)
                let action1 = UIAlertAction(title: "OK",style: .destructive,handler: {action in print("Not able to fetch weather")})
                alert.addAction(action1)
                self.present(alert,animated: true,completion: {print("Done")})
                self.getCurrentLocationWeatherButton.isEnabled = true
                self.getCityWeatherButton.isEnabled = self.cityTextField.text?.characters.count > 0
        }
        print("weatherGetFail error: \(error)")
    }
    
    
    func fetchLoaction()
    {
        guard CLLocationManager.locationServicesEnabled() else
        {
            let alert = UIAlertController(title: "Location access restriced",message: "Go to Settings → Privacy → Location Services to turn on location access.",preferredStyle: .alert)
            let action1 = UIAlertAction(title: "OK",style: .destructive,handler: {action in print("Turn on location")})
            alert.addAction(action1)
            self.present(alert,animated: true,completion: {print("Done")})
            getCurrentLocationWeatherButton.isEnabled = true
            return
        }
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        guard authorizationStatus == .authorizedWhenInUse else
        {
            switch authorizationStatus
            {
            case .denied, .restricted:
                let alert = UIAlertController(title: "Location services disabled",message: "Go to Settings → Privacy → Location Services to turn on location access to enable.",preferredStyle: .alert)
                let cancelSelect = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsSelection = UIAlertAction(title: "Open Settings", style: .default)
                {
                    action in
                    if let url = URL(string: UIApplicationOpenSettingsURLString)
                    {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alert.addAction(cancelSelect)
                alert.addAction(openSettingsSelection)
                present(alert, animated: true, completion: nil)
                getCurrentLocationWeatherButton.isEnabled = true
                return
                
            case .notDetermined:
                location1.requestWhenInUseAuthorization()
            default:
                print("Oops! Shouldn't have come this far.")
            }
            return
        }
        location1.delegate = self
        location1.desiredAccuracy = kCLLocationAccuracyBest
        location1.requestLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let updatedLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: updatedLocation.coordinate.latitude,longitude: updatedLocation.coordinate.longitude)
    }


    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        DispatchQueue.main.async
            {
                let alert = UIAlertController(title: "Unable to fetch location",message: "Location Manager is not responding.",preferredStyle: .alert)
                let fetchAction = UIAlertAction(title: "OK",style: .destructive,handler: {action in print("Unable to fetch location")})
                alert.addAction(fetchAction)
                self.present(alert,animated: true,completion: {print("Done")})
        }
        print("locationManager didFailWithError: \(error)")
    }
    
    
    
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        let text = textField.text ?? ""
        let editedText = (text as NSString).replacingCharacters(in: range,with: string).trimmingCharacters(in: CharacterSet.whitespaces)
        getCityWeatherButton.isEnabled = editedText.characters.count > 0
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        getWeatherForCityTapped(getCityWeatherButton)
        return true
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        textField.text = ""
        getCityWeatherButton.isEnabled = false
        return true
    }
       
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        view.endEditing(true)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let passingValue = segue.destination as! InfoViewController
        passingValue.passedValue = cityLabel.text!
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.isNavigationBarHidden = true
        
        super.viewWillAppear(animated)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    
    private func supportedInterfaceOrientations()-> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    
    private func shouldAutorotate() -> Bool {
        return true
    }
    
}
