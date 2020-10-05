//
//  AddLocationVC.swift
//  On-The-Map
//
//  Created by António Bastião on 03.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit
import CoreLocation

class AddLocationVC : UIViewController {
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addUrlTextField: UITextField!
    
    @IBAction func getGeoCoding(_ sender: Any) {
        
        guard let address = addAddressTextField.text else {
            return
        }
        
        CLGeocoder().geocodeAddressString(address) {placemarks, error in
            
            if let error = error {
                print("Error", error)
                return
            }
            
            if let location = placemarks?.first?.location {
                let coordinates:CLLocationCoordinate2D = location.coordinate
                print(coordinates)
            }
            
        }
    }
    
}
