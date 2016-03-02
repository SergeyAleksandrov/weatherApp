//
//  ViewController.swift
//  WeatherApp
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, DestinationViewDelegate {

   
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var humLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherImageViewer: UIImageView!
    
    var cityName = String()
    var prevCityName = String()
    
    let moc = DataController().managedObjectContext
    
    @IBAction func RefreshButton(sender: AnyObject) {
        setDataLabeles()
        
    }
    
    
    @IBAction func SetCityButton(sender: AnyObject) {
        prevCityName = cityLabel.text!
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        setDataLabeles()
        citiesInitialization()
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataLabeles() {
        
        var paramWeather: [String] = []
        
        if cityLabel.text! == "" {
            
            paramWeather = fetchCity()
            if !paramWeather.isEmpty {
                cityLabel.text = paramWeather[0]
            } else {
                cityLabel.text = "London"
            }
            
        }
        
        if Weather.isConnectedToNetwork() {
            
            let tWeath: Weather = Weather()
            
            tWeath.displayURL(cityLabel.text!) { error in
                
                if error != nil {
                    self.cityLabel.text = self.prevCityName
                    self.alertMessage("Alert", msgMs: "Error getting city")
                } else {
                    if tWeath.nameCityOut != "n/a" {
                        self.cityLabel.text = tWeath.nameCityOut
                        self.tempLabel.text = tWeath.tempOut
                        self.humLabel.text = tWeath.humOut
                        self.windLabel.text = tWeath.windOut
                        
                        if tWeath.iconWeatherOut == "n/a" {
                            self.weatherImageViewer.image = UIImage(named: "na")
                        } else {
                            let imgURL: NSURL = NSURL(string: "http://openweathermap.org/img/w/\(tWeath.iconWeatherOut).png")!
                            let imgData: NSData = NSData(contentsOfURL: imgURL)!
                            self.weatherImageViewer.image = UIImage(data: imgData)
                        }
                        
                        self.saveCity(tWeath)
                        print(tWeath.windOut+tWeath.humOut+tWeath.nameCityOut+tWeath.iconWeatherOut+tWeath.tempOut)
                    } else {
                        self.cityLabel.text = self.prevCityName
                        self.alertMessage("Alert", msgMs: "Error getting city")
                    }
                }
                
                
            }
            
        } else {
            if !paramWeather.isEmpty {
                self.cityLabel.text = paramWeather[0]
                self.tempLabel.text = paramWeather[1]
                self.humLabel.text = paramWeather[2]
                self.windLabel.text = paramWeather[3]
                self.weatherImageViewer.image = UIImage(named: "na")
            }
            
            alertMessage("Alert", msgMs: "No internet connection")
            
        }
  
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "setCitySegue"){
            let destination = segue.destinationViewController as! SetCityViewController
            destination.delegate = self
            destination.preCityName = cityLabel.text
        }
    }

    
    func setCtyName(nameCity: String){
        
        if Weather.isConnectedToNetwork() {
            cityLabel.text = nameCity
            setDataLabeles()
        } else {
            alertMessage("Alert", msgMs: "No internet connection")
        }
        
    }
    
    
    func alertMessage(titleMs: String, msgMs: String){
        // No internet cooection
        
        let alertController = UIAlertController(title: titleMs, message: msgMs, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in}
        
        alertController.addAction(okButton)
        
        presentViewController(alertController, animated: true, completion: nil)
       
    
    }
    
    
    func fetchCity() -> [String] {
        
        let weatherFetch = NSFetchRequest(entityName: "CityWeather")
        
        do {
            let fetchweather = try moc.executeFetchRequest(weatherFetch) as! [CityWeather]
            return [fetchweather[0].name!,fetchweather[0].temp!,fetchweather[0].hum!,fetchweather[0].wind!,fetchweather[0].icon!]
            //print(fetchweather.first!.name!)
            
        } catch {
            fatalError("bad things happened \(error)")
        }
        
       return []
    }
    
    
    func saveCity(ctWeather: Weather)
    {
        let weatherFetch = NSFetchRequest(entityName: "CityWeather")
        
        do {
            let fetchWeather = try moc.executeFetchRequest(weatherFetch) as! [CityWeather]
            var entity: CityWeather? = nil
            
            if !fetchWeather.isEmpty {
                entity = fetchWeather[0]
            } else {
                entity = (NSEntityDescription.insertNewObjectForEntityForName("CityWeather", inManagedObjectContext: moc) as! CityWeather)
            }
            
            entity!.setValue(ctWeather.nameCityOut, forKey: "name")
            entity!.setValue(ctWeather.tempOut, forKey: "temp")
            entity!.setValue(ctWeather.humOut, forKey: "hum")
            entity!.setValue(ctWeather.windOut, forKey: "wind")
            entity!.setValue(ctWeather.iconWeatherOut, forKey: "icon")
            
            do {
                try moc.save()
            } catch {
                fatalError( "Fail to save data: \(error)")
            }

            //print(fetchweather.first!.name!)
            
        } catch {
            fatalError("Error: \(error)")
        }
    
    }
    
    
    func citiesInitialization()
    {
        let cities: [String] = ["703448", "4905599", "2950159", "6094817", "5128581", "625144", "7536080", "593116", "1273294", "756135", "323786", "456172", "2988507", "2759794", "2761367", "2643743", "3117735", "658225", "5344157", "1267182"]
        
        let weatherFetch = NSFetchRequest(entityName: "CitiesWeather")
        
        do {
          
            let fetchWeather = try moc.executeFetchRequest(weatherFetch) as! [CitiesWeather]
         
            if fetchWeather.count == 0 {
                
                for var i=0; i < cities.count; i++ {
                    
                  let  entity = NSEntityDescription.insertNewObjectForEntityForName("CitiesWeather", inManagedObjectContext: moc) as! CitiesWeather
                    
                    entity.setValue(cities[i], forKey: "idCity")
                }
                    
                do {
                    try moc.save()
                } catch {
                    fatalError( "Fail to save data: \(error)")
                }
                
            }

        } catch {
            fatalError("Error: \(error)")
        }
        
    }
    
    
    
}

