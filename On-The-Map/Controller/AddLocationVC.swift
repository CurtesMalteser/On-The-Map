//
//  AddLocationVC.swift
//  On-The-Map
//
//  Created by António Bastião on 03.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationVC : UIViewController {
    
    var locationState: LocationState = EmptyLocationState()
    
    lazy var locationErrorMessage = """
Unable to find your location.
Please try to change address.
"""
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addUrlTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    @IBAction func getGeoCoding(_ sender: Any) {
        
        if(locationState is EnabledLocationState){
            guard let address = addAddressTextField.text else {
                return
            }
            
            CLGeocoder().geocodeAddressString(address) {placemarks, error in
                
                if error != nil {
                    self.showErrorAlert(message: self.locationErrorMessage)
                    return
                }
                
                if let location = placemarks?.first?.location {
                    let coordinates:CLLocationCoordinate2D = location.coordinate
                    print(coordinates)
                    
                    self.locationMapView.positionOnMapCoordinates(coordinates)
                    
                    self.locationState = self.findLocationButton.enablePostLocation(address, coordinates: coordinates)
                }
                
            }
            
        } else if(locationState is ReadyLocationState) {
            
            let readyLocationState = (locationState as! ReadyLocationState)
            print("locationState \(readyLocationState) \(readyLocationState.address) \(readyLocationState.coordinates)")
            
            let studentProfile = StudentRepository.sharedInstance.studentProfile!
            
            print("studentProfile \(studentProfile)")
            
            let url = addUrlTextField.text!
            var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"uniqueKey\": \"\(studentProfile.uniqueKey)\", \"firstName\": \"\(studentProfile.firstName)\", \"lastName\": \"\(studentProfile.lastName)\",\"mapString\": \"\(readyLocationState.address)\", \"mediaURL\": \"\(url)\",\"latitude\": \(readyLocationState.coordinates.latitude), \"longitude\": \(readyLocationState.coordinates.longitude)}".data(using: .utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, response, error in
              if error != nil { // Handle error…
                  return
              }
              print(String(data: data!, encoding: .utf8)!)
            }
            task.resume()
            
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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

fileprivate extension MKMapView {
    func positionOnMapCoordinates(_ coordinates: CLLocationCoordinate2D) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        setRegion(region, animated: true)
        
        addAnnotation(pin)
    }
}
