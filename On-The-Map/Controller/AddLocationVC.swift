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
    
    var locationState: LocationState = EmptyLocationState()
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addUrlTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBAction func getGeoCoding(_ sender: Any) {
        
        if(locationState is EnabledLocationState){
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
                    
                    self.locationState = self.findLocationButton.enablePostLocation(address, coordinates: coordinates)
                }
                
            }
            
        } else if(locationState is ReadyLocationState) {
            print("locationState \(locationState) \(locationState.address) \((locationState as! ReadyLocationState).coordinates)")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationState = findLocationButton.disableFindLocation()
        addAddressTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(addAddressTextField: UITextField) {
        
        let text = addAddressTextField.text ?? ""
        if(text.count != 0){
            locationState = findLocationButton.enableFindLocation(text)
        } else {
            locationState = findLocationButton.disableFindLocation()
        }
        
    }
}

fileprivate extension UIButton {
    func disableFindLocation() -> EmptyLocationState {
        isEnabled = false
        alpha = 0.5
        setTitle("Find Location".capitalized, for: UIControl.State.normal)
        return EmptyLocationState()
    }
    
    func enableFindLocation(_ address: String) -> EnabledLocationState {
        isEnabled = true
        alpha = 1
        setTitle("Find Location", for: UIControl.State.normal)
        return EnabledLocationState(address: address)
    }
    
    func enablePostLocation(_ address: String, coordinates:CLLocationCoordinate2D) -> ReadyLocationState {
        if(isEnabled == false) { isEnabled = true }
        if(alpha != 1) { alpha = 1 }
        setTitle("finish".capitalized, for: UIControl.State.normal)
        return ReadyLocationState(address: address, coordinates: coordinates)
    }
}
