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
    
    @IBOutlet weak var cityEditText: UITextField!
    @IBAction func setCityButton(sender: AnyObject) {
        

    delegate.setCtyName(cityEditText.text!)
    self.dismissViewControllerAnimated(true, completion: nil)
//    self.navigationController?.popToRootViewControllerAnimated(true)
    
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
   
}
