//
//  Weather.swift
//  Weather
//
//  Created by Venkateshprasad Ashwathnarayana on 12/15/16.
//  Copyright © 2016 Venkateshprasad Ashwathnarayana. All rights reserved.
//

import Foundation

protocol WeatherDelegate
{
    func weatherGetSuccess(_ weather: Weather)
    func weatherGetFail(_ error: NSError)
}

struct Weather
{
    let country: String
    let city: String
    let longitude: Double
    let latitude: Double
    let dateAndTime: Date
    
    let weatherID: Int
    let weatherDescription: String
    let mainWeather: String
    let weatherIconID: String
    
    let temperature: Double
    var tempCelsius: Double
        {
        get
        {
            return round(temperature - 273.15)
        }
    }
    var tempFahrenheit: Double
        {
        get
        {
            return round((temperature - 273.15) * 1.8 + 32)
        }
    }
    
   let tempMax: Double
    var tempMaxCelsius: Double
        {
        get
        {
            return round(tempMax - 273.15)
        }
    }
    var tempMaxFahrenheit: Double
        {
        get
        {
            return round((tempMax - 273.15) * 1.8 + 32)
        }
    }
    
    let tempMin: Double
    var tempMinCelsius: Double
        {
        get
        {
            return round(tempMin - 273.15)
        }
    }
    var tempMinFahrenheit: Double
        {
        get
        {
            return round((tempMin - 273.15) * 1.8 + 32)
        }
    }
    
    let cloudCover: Int
    let rainfall: Double?
    
    let windSpeed: Double
    let windDirection: Double?
    
    let humidity: Int
    let pressure: Int
    
    let sunrise: Date
    let sunset: Date
    
    init(weatherData: [String: AnyObject])
    {
        dateAndTime = Date(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        
        let coordDict = weatherData["coord"] as! [String: AnyObject]
        
        longitude = coordDict["lon"] as! Double
        latitude = coordDict["lat"] as! Double
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        
        weatherID = weatherDict["id"] as! Int
        weatherDescription = weatherDict["description"] as! String
        mainWeather = weatherDict["main"] as! String
        weatherIconID = weatherDict["icon"] as! String
        
        let mainDict = weatherData["main"] as! [String: AnyObject]
        
        temperature = mainDict["temp"] as! Double
        tempMax = mainDict["temp_max"] as! Double
        tempMin = mainDict["temp_min"] as! Double
        
        cloudCover = weatherData["clouds"]!["all"] as! Int
        humidity = mainDict["humidity"] as! Int
        pressure = mainDict["pressure"] as! Int
        
        let windDict = weatherData["wind"] as! [String: AnyObject]
        windSpeed = windDict["speed"] as! Double
        windDirection = windDict["deg"] as? Double
        
        if weatherData["rain"] != nil
        {
            let rainDict = weatherData["rain"] as! [String: AnyObject]
            rainfall = rainDict["3h"] as? Double
        }
        else
        {
            rainfall = nil
        }
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        country = sysDict["country"] as! String
        sunrise = Date(timeIntervalSince1970: sysDict["sunrise"] as! TimeInterval)
        sunset = Date(timeIntervalSince1970:sysDict["sunset"] as! TimeInterval)
    }
    
}




class WeatherGetter
{
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    fileprivate let openWeatherMapAPIKey = "ce983596c0938bc21785ec95b6b251e7"
    
    fileprivate var delegate: WeatherDelegate
    
    init(delegate: WeatherDelegate)
    {
        self.delegate = delegate
    }
    
    func getWeatherByCity(_ city: String)
    {
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        getWeather(weatherRequestURL)
        
    }
    
    func getWeatherByCoordinates(latitude: Double, longitude: Double)
    {
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(latitude)&lon=\(longitude)")!
        getWeather(weatherRequestURL)
    }
    
    fileprivate func getWeather(_ weatherRequestURL: URL)
    {
        
        let session = URLSession.shared
        session.configuration.timeoutIntervalForRequest = 3
        
        let dataTask = session.dataTask(with: weatherRequestURL)
        {
            (data, response, error) -> Void in
            if let networkError = error
            {
                self.delegate.weatherGetFail(networkError as NSError)
            }
            else
            {
                do
                {
                    let weatherData = try JSONSerialization.jsonObject(with: data!,options: .mutableContainers) as! [String: AnyObject]
                    
                    let weather = Weather(weatherData: weatherData)
                    self.delegate.weatherGetSuccess(weather)
                }
                catch let jsonError as NSError
                {
                    self.delegate.weatherGetFail(jsonError)
                }
            }
        }
        
        dataTask.resume()
    }
}

