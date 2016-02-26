//
//  ViewController.swift
//  WeatherApp
//
//  Created by Admin on 25.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DestinationViewDelegate {

   
    @IBOutlet weak var cityLabel: UILabel!
  
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var humLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var weatherImageViewer: UIImageView!
    
    var cityName = String()
    
    @IBAction func RefreshButton(sender: AnyObject) {
        setDataLables()
        
    }
    var paramWeather: [String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityLabel.text = cityName
        setDataLables()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDataLables() {
        
        if cityLabel.text! == "" {
           cityLabel.text = "London"
        }
        
        let tWeath: CityWeather = CityWeather()
        paramWeather = tWeath.displayURL(cityLabel.text!)
        self.cityLabel.text = paramWeather[0]
        self.tempLabel.text = paramWeather[1]
        self.humLabel.text = paramWeather[2]
        self.windLabel.text = paramWeather[3]
        
        let imgURL: NSURL = NSURL(string: "http://openweathermap.org/img/w/\(paramWeather[4]).png")!
        let imgData: NSData = NSData(contentsOfURL: imgURL)!
        self.weatherImageViewer.image = UIImage(data: imgData)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "setCitySegue"){
            let destination = segue.destinationViewController as! SetCityViewController
            destination.delegate = self
            destination.preCityName = cityLabel.text
        }
    }

    
    func setCtyName(nameCity: String)
    {
        cityLabel.text = nameCity
        setDataLables()
    }
}

