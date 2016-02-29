//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Admin on 27.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import CoreData


class CityWeather: NSManagedObject {

    @NSManaged var hum: String?
    @NSManaged var name: String?
    @NSManaged var temp: String?
    @NSManaged var wind: String?
    @NSManaged var icon: String?

}


class CitiesWeather: NSManagedObject {
    
    @NSManaged var hum: String?
    @NSManaged var name: String?
    @NSManaged var temp: String?
    @NSManaged var idCity: String?
    
}