//
//  TodayViewController.swift
//  WeatherWidget
//
//  Created by Venkateshprasad Ashwathnarayana on 12/18/16.
//  Copyright © 2016 Venkateshprasad Ashwathnarayana. All rights reserved.
//

import UIKit
import NotificationCenter
import WeatherGetter
import CoreLocation

class TodayViewController: UIViewController, NCWidgetProviding, WeatherDelegate, CLLocationManagerDelegate {
    
    
   
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    
    @IBOutlet var weatherConditionLabel: UILabel!
    var weather:WeatherGetter!
    let defaults = UserDefaults(suiteName: "group.weatherapp.cityname")
    
    override func viewDidLoad()
    {
        weather = WeatherGetter(delegate: self)
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.compact
        defaults?.synchronize()
        weather.getWeatherByCity(getCityName())
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func getCityName () -> String
    {
        var cityname = ""
        if let restoredValue = defaults!.string(forKey: "cityname")
        {
            cityname = restoredValue.lowercased()
            return cityname
            
        }
        else
        {
            cityname = "sandiego"
            return cityname
        }
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void))
    {
        weather.getWeatherByCity(getCityName())
        completionHandler(NCUpdateResult.newData)
    }
    
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets
    {
        
        return UIEdgeInsets.zero
    }
    
    
    func weatherGetSuccess(_ weather: Weather)
    {
        DispatchQueue.main.async
        {
            self.tempLabel.text = "\(weather.tempFahrenheit)°F"
            self.cityNameLabel.text = "\(weather.city)"
            self.weatherConditionLabel.text = "\(weather.weatherDescription.uppercased())"
            
        }
    }
    
    
    func weatherGetFail(_ error: NSError)
    {
        print("weatherGetFail error: \(error)")
    }
    
    
    
    
    
}
