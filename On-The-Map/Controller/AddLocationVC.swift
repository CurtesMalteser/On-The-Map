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
    
    @IBOutlet weak var findLocationButton: UIButton!
    
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
                
                self.findLocationButton.enablePostLocation()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        findLocationButton.disableFindLocation()
        addAddressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(addAddressTextField: UITextField) {
        
        let text = addAddressTextField.text ?? ""
        if(text.count != 0){
            findLocationButton.enableFindLocation()
        } else {
            findLocationButton.disableFindLocation()
        }
        
    }
}

fileprivate extension UIButton {
    func disableFindLocation() {
        isEnabled = false
        alpha = 0.5
        setTitle("Find Location".capitalized, for: UIControl.State.normal)
    }
    
    func enableFindLocation() {
        isEnabled = true
        alpha = 1
        setTitle("Find Location", for: UIControl.State.normal)
    }
    
    func enablePostLocation() {
        if(isEnabled == false) { isEnabled = true }
        if(alpha != 1) { alpha = 1 }
        setTitle("finish".capitalized, for: UIControl.State.normal)
    }
}
