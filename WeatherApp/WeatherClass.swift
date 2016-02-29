//
//  WeatherClass.swift
//  WeatherApp
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration


class Weather {

    func displayURL(nCity: String) -> [String] {
        
        var nameCityOut = "n/a"
        var tempOut = "n/a"
        var windOut = "n/a"
        var humOut = "n/a"
        var iconWeatherOut = "n/a"
        
        var param: [String] = [nameCityOut, tempOut, humOut, windOut, iconWeatherOut]
        let myURLAdress = "http://api.openweathermap.org/data/2.5/weather?q=\(nCity.stringByReplacingOccurrencesOfString(" ", withString: ""))&appid=e06513ffb372a74433c5e0971f587432"
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
                    tempOut = "+\(Int(temp!)) ºC"
                }else if temp < 0 {
                    tempOut = "\(Int(temp!)) ºC"
                }else{
                    tempOut = "0 ºC"
                }
                
                windOut = "wind: \(Int(wind!)) m/s"
                humOut = "humidity: \(hum) %"
                nameCityOut = "\(nameCity)"
                iconWeatherOut = "\(iconWeather)"

                param = [nameCityOut, tempOut, humOut, windOut, iconWeatherOut]
                isTaskRun = false
                
            }else{
                isTaskRun = false
            }
            
        }
        
        URLTask.resume()
        while isTaskRun {
                // waiting 
        }
        return param
       
    }
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    
    
    
}

