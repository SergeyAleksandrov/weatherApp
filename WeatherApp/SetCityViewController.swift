//
//  SetCityViewController.swift
//  WeatherApp
//
//  Created by Admin on 26.02.16.
//  Copyright © 2016 Admin. All rights reserved.
//

import Foundation
import UIKit

protocol DestinationViewDelegate {
    func setCtyName(cityName: String);
}

class SetCityViewController: UIViewController{
    
    var preCityName: String! = nil
    var delegate: DestinationViewDelegate! = nil
    
    @IBAction func cancelButton(sender: AnyObject) {
        delegate.setCtyName("c_n_c_l")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet weak var cityEditText: UITextField!
    
    @IBAction func setCityButton(sender: AnyObject) {
        
        if  cityEditText.text == "" {
            let alertController = UIAlertController(title: "Alert", message: "Please, enter city", preferredStyle: .Alert)
            
            let okButton = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in}
            
            alertController.addAction(okButton)
            
            presentViewController(alertController, animated: true, completion: nil)
        } else {
            
            if cityEditText.text != preCityName {
                delegate.setCtyName(cityEditText.text!)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
   
}
