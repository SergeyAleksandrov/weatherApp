//
//  WeatherClass.swift
//  WeatherApp
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation


class CityWeather {
    
    var nameCityOut: String = "n/a"
    var tempOut: String = "n/a"
    var windOut: String = "n/a"
    var humOut: String = "n/a"
    var iconWeatherOut: String = "n/a"
   
    
    func displayURL(nCity: String) -> [String] {
        
        var param: [String]=[]
        let myURLAdress = "http://api.openweathermap.org/data/2.5/weather?q=\(nCity)&appid=e06513ffb372a74433c5e0971f587432"
        let myURL = NSURL(string: myURLAdress)
        
        var isTaskRun = true
        
        let URLTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!){
            myData, response, error in
            
            guard error == nil else {
                isTaskRun = false
                return
            }
  
            let json = JSON(data: myData!)
            let cod = json["cod"].int
            
            if cod == 200 {
                
                let iconWeather = json["weather"][0]["icon"]
                let nameCity = json["name"]
                var temp = json["main"]["temp"].double
                var wind = json["wind"]["speed"].double
                let hum = json["main"]["humidity"]
               
                temp = round(temp! - 273)
                wind = round(wind!)
                
                if temp > 0 {
                    self.tempOut = "+\(Int(temp!)) ºC"
                }else if temp < 0 {
                    self.tempOut = "\(Int(temp!)) ºC"
                }else{
                    self.tempOut = "0 ºC"
                }
                
                self.windOut = "wind: \(Int(wind!)) m/s"
                self.humOut = "humidity: \(hum) %"
                self.nameCityOut = "\(nameCity)"
                self.iconWeatherOut = "\(iconWeather)"
                
                //print("city - \(nameCity) temp - \(temp!) wind - \(wind!) hum - \(hum) iconWeather - \(iconWeather) cod - \(cod)")
                param = [self.nameCityOut, self.tempOut, self.humOut, self.windOut, self.iconWeatherOut]
                isTaskRun = false
                
            }else{
                isTaskRun = false
                print("Error")
            }
            
        }
        
        URLTask.resume()
        while isTaskRun {
                // waiting 
        }
        return param
       
    }
    
}

