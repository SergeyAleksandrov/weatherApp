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
import SwiftyJSON

class TabViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let moc = DataController().managedObjectContext
    
    var Cells: [String] = []
    var citiesW:[String] = []
    
    @IBAction func returnMainPage(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self,  forCellReuseIdentifier: "cell")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
        self.getWeatherCities()
        }
        
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
    
    
    func getWeatherCities(){
       
        citiesW = []
        
        let weatherFetch = NSFetchRequest(entityName: "CitiesWeather")
        var fetchWeather: [CitiesWeather] = []
        do {
            
             fetchWeather = try moc.executeFetchRequest(weatherFetch) as! [CitiesWeather]
            
             if fetchWeather.count == 0 {
                
                alertMessage("Alert", msgMs: "Output error")
                
            } else {
                
                if Weather.isConnectedToNetwork() {
                    
                    parsingCtsJSON(fetchWeather){ error in
                        
                        if error != nil {
                            print("Error: \(error)")
                        }
                    }
                    
                } else {
                    
                    for itemsCt in fetchWeather {
                        citiesW.append("\(itemsCt.name!): \(itemsCt.temp!)  hum \(itemsCt.hum!)%")
                    }
                    self.Cells = self.citiesW
                    alertMessage("Alert", msgMs: "No internet connection")
                    
                }
                
            }
            
        } catch {
            fatalError("Error: \(error)")
        }
        
        
    }
    
    
    
    func parsingCtsJSON(fetchCtsWeather: [CitiesWeather], completionHandler: (NSError?) -> Void ) -> NSURLSessionTask {
        
        var nameCts: [String] = []
        var tempCts: [String] = []
        var humCts: [String] = []
        var idsCts: [String] = []
   
        var idsRequestCities = String()
        
        for var i = 0; i <  fetchCtsWeather.count; i++ {
            
            if i == 0 {
                idsRequestCities += fetchCtsWeather[i].idCity!
            } else {
                idsRequestCities += ",\(fetchCtsWeather[i].idCity!)"
            }
            
        }
       
        let myURLAdress = "http://api.openweathermap.org/data/2.5/group?id=\(idsRequestCities)&units=metric&appid=e06513ffb372a74433c5e0971f587432"
        let myURL = NSURL(string: myURLAdress)
        let URLTask = NSURLSession.sharedSession().dataTaskWithURL(myURL!){ myData, response, error ->  Void in
            
            if error != nil {
                completionHandler(error)
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
                
                for itemsCt in fetchCtsWeather {
                    
                    let cityIndex = idsCts.indexOf(itemsCt.idCity!)
                    if cityIndex != nil {
                        self.citiesW.append("\(nameCts[cityIndex!]): \(tempCts[cityIndex!])  hum \(humCts[cityIndex!])%")
                        itemsCt.setValue(nameCts[cityIndex!], forKey: "name")
                        itemsCt.setValue(tempCts[cityIndex!], forKey: "temp")
                        itemsCt.setValue(humCts[cityIndex!], forKey: "hum")
                    }
                    
                }
                self.Cells = self.citiesW
                
                self.tableView.reloadData()
                do {
                    try self.moc.save()
                } catch {
                    fatalError( "Fail to save data: \(error)")
                }
                
                completionHandler(nil)
                return
                
            }else{
                
                completionHandler(nil)
                return
                
            }
            
        }
        
        URLTask.resume()
        return URLTask
        
    }
    
    
    
    func alertMessage(titleMs: String, msgMs: String){
        
        let alertController = UIAlertController(title: titleMs, message: msgMs, preferredStyle: .Alert)
        
        let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in}
        
        alertController.addAction(okButton)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
    }
    
    
}