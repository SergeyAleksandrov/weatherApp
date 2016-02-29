//
//  TabViewController.swift
//  WeatherApp
//
//  Created by Admin on 28.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class TabViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let moc = DataController().managedObjectContext
    
    var Cells: [String] = []
    
    
    @IBAction func returnMainPage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self,  forCellReuseIdentifier: "cell")
        Cells = getWeatherCities()
        getWeatherCities()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Cells.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel!.text = Cells[indexPath.row]
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            Cells.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    
    func getWeatherCities() -> [String]{
        
        var nameCts: [String] = []
        var tempCts: [String] = []
        var humCts: [String] = []
        var idsCts: [String] = []
        
        var idsRequestCities = String()
        var citiesW:[String] = []

        let weatherFetch = NSFetchRequest(entityName: "CitiesWeather")
        var fetchWeather: [CitiesWeather] = []
        do {
            
             fetchWeather = try moc.executeFetchRequest(weatherFetch) as! [CitiesWeather]
            
             if fetchWeather.count == 0 {
                
                alertMessage("Alert", msgMs: "Output error")
                
            } else {
                
                if Weather.isConnectedToNetwork() {
                    for var i = 0; i <  fetchWeather.count; i++ {
                        
                        if i == 0 {
                            idsRequestCities += fetchWeather[i].idCity!
                        } else {
                            idsRequestCities += ",\(fetchWeather[i].idCity!)"
                        }
                        
                    }
                    
                    var isTaskRun = true
                    
                    let myURLAdress = "http://api.openweathermap.org/data/2.5/group?id=\(idsRequestCities)&units=metric&appid=e06513ffb372a74433c5e0971f587432"
                    let myURL = NSURL(string: myURLAdress)
                    let URLTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!){
                        myData, response, error in
                        
                        guard error == nil else {
                            isTaskRun = false
                            return
                        }
                        
                        let json = JSON(data: myData!)
                        let cnt = json["cnt"].int
                        
                        if cnt > 0 {
                            
                            for var k = 0; k < cnt ; k++ {
                                
                                nameCts.append(String(json["list"][k]["name"]))
                                idsCts.append(String(json["list"][k]["id"]))
                                
                                var tempr = json["list"][k]["main"]["temp"].double
                                
                                tempr = round(tempr!)
                                
                                if tempr > 0 {
                                    tempCts.append("+\(Int(tempr!)) ºC")
                                }else if tempr < 0 {
                                    tempCts.append("\(Int(tempr!)) ºC")
                                }else{
                                    tempCts.append("0 ºC")
                                }
                                
                                humCts.append(String(json["list"][k]["main"]["humidity"]))
                                
                            }
                            
                            for itemsCt in fetchWeather {
                                
                                let cityIndex = idsCts.indexOf(itemsCt.idCity!)
                                if cityIndex != nil {
                                    citiesW.append("\(nameCts[cityIndex!]): \(tempCts[cityIndex!])  hum \(humCts[cityIndex!])%")
                                    itemsCt.setValue(nameCts[cityIndex!], forKey: "name")
                                    itemsCt.setValue(tempCts[cityIndex!], forKey: "temp")
                                    itemsCt.setValue(humCts[cityIndex!], forKey: "hum")
                                }
                                
                            }
                                                        
                            do {
                                try self.moc.save()
                            } catch {
                                fatalError( "Fail to save data: \(error)")
                            }
                            
                            isTaskRun = false
                            
                        }else{
                            
                            isTaskRun = false
                            
                        }
                        
                    }
                    
                    URLTask.resume()
                    while isTaskRun {
                        // waiting
                    }
                } else {
                    
                    for itemsCt in fetchWeather {
                        citiesW.append("\(itemsCt.name!): \(itemsCt.temp!)  hum \(itemsCt.hum!)%")
                    }
                    
                    alertMessage("Alert", msgMs: "No internet connection")
                    
                }
                
            }
            
        } catch {
            fatalError("Error: \(error)")
        }
        
        return citiesW
    }
    
    
    
    func alertMessage(titleMs: String, msgMs: String){
        
        let alertController = UIAlertController(title: titleMs, message: msgMs, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in}
        
        alertController.addAction(okButton)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
}