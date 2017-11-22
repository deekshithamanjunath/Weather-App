//
//  InfoViewController.swift
//  Weather
//
//  Created by Venkateshprasad Ashwathnarayana on 12/15/16.
//  Copyright © 2016 Venkateshprasad Ashwathnarayana. All rights reserved.
//

import UIKit
import CoreLocation
import WeatherGetter


class InfoViewController: UIViewController, WeatherDelegate
{
    var myStringValue:String = ""
    var passedValue = ""
    var weather: WeatherGetter!
    
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var maxTempFLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var minTempFLabel: UILabel!
    @IBOutlet var cloudsLabel: UILabel!
    @IBOutlet var rainLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet var sunRise: UILabel!
    @IBOutlet var sunSet: UILabel!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        let cityName = passedValue
        weather.getWeatherByCity(cityName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!)
    }
    
    
    


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    
    func weatherGetSuccess(_ weather: Weather)
    {
        
        DispatchQueue.main.async
            {
            self.maxTempLabel.text = "\(weather.tempMaxFahrenheit)°F"
            self.maxTempFLabel.text = "\(weather.tempMaxCelsius)°C"
            self.minTempLabel.text = "\(weather.tempMinFahrenheit)°F"
            self.minTempFLabel.text = "\(weather.tempMinCelsius)°C"
            self.cloudsLabel.text = "\(weather.cloudCover)%"
            self.windLabel.text = "\(weather.windSpeed) m/s"
                
            if let rain = weather.rainfall
                {
                self.rainLabel.text = "\(rain) mm"
                }
                else
                {
                  self.rainLabel.text = "None"
                }
                
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
        self.humidityLabel.text = "\(weather.humidity)%"
        self.pressureLabel.text = "\(weather.pressure)P"
        
        self.sunRise.text = "\(weather.sunRiseTime)"
        self.sunSet.text = "\(weather.sunSetTime)"
                
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
        }
        print("weatherGetFail error: \(error)")
    }

    
}
