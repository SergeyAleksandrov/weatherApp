//
//  WeatherClass.swift
//  WeatherApp
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration
import SwiftyJSON

class Weather {

    var nameOut = String()
    var tempOut = String()
    var windOut = String()
    var humOut = String()
    var iconOut = String()
    
    func parsingCityJSON(nCity: String, completionHandler: (NSError?) -> Void ) -> NSURLSessionTask {
        
        nameOut = "n/a"
        tempOut = "n/a"
        windOut = "n/a"
        humOut = "n/a"
        iconOut = "n/a"
        
        let myURLAdress = "http://api.openweathermap.org/data/2.5/weather?q=\(nCity)&appid=e06513ffb372a74433c5e0971f587432"
        let myURL = NSURL(string: myURLAdress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
        let URLTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!){ myData, response, error -> Void in
            
            if error != nil {
                completionHandler(error)
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
                self.nameOut = "\(nameCity)"
                self.iconOut = "\(iconWeather)"
                //print(self.windOut+self.humOut+self.nameCityOut+self.iconWeatherOut+self.tempOut)
                
                completionHandler(nil)
                return
               
            }
            completionHandler(nil)
            return
        }
        
        URLTask.resume()
        return URLTask
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

