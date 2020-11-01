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
    private lazy var networkActivityAlert = self.showNetworkActivityAlert()
    
    @IBOutlet weak var addAddressTextField: UITextField!
    
    @IBOutlet weak var addUrlTextField: UITextField!
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBOutlet weak var locationMapView: MKMapView!
    
    @IBAction func getGeoCoding(_ sender: Any) {
        
        if(locationState is EnabledLocationState){
            guard let address = addAddressTextField.text else {
                return
            }
            
            self.present(networkActivityAlert, animated: true, completion: nil)
            
            CLGeocoder().geocodeAddressString(address) {placemarks, error in
                
                if error != nil {
                    self.networkActivityAlert.dismiss(animated: false, completion: {
                        self.showErrorAlert(message: self.locationErrorMessage)
                    })
                    
                    return
                }
                
                if let location = placemarks?.first?.location {
                    let coordinates:CLLocationCoordinate2D = location.coordinate
                    print(coordinates)
                    
                    self.locationMapView.positionOnMapCoordinates(coordinates)
                    
                    self.locationState = self.findLocationButton.enablePostLocation(address, coordinates: coordinates)
                    
                    self.networkActivityAlert.dismiss(animated: false, completion: nil)
                }
                
            }
            
        } else if(locationState is ReadyLocationState) {
            
            let readyLocationState = (locationState as! ReadyLocationState)
                      
            let studentProfile = StudentRepository.sharedInstance.studentProfile!
            
            let mediaURL = addUrlTextField.text ?? ""
            
            let url = URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!
            
            let session = URLSession.shared
            
            self.present(networkActivityAlert, animated: true, completion: nil)
            
            let request = UdacityAPI.postStudentLocationRequest(url: url, studentProfile: studentProfile, readyLocationState:readyLocationState, mediaURL: mediaURL)
            
            let task = session.dataTask(with: request) { data, response, error in
                if error != nil { // Handle error…
                    DispatchQueue.main.async {
                        self.networkActivityAlert.dismiss(animated: false, completion: {
                            self.showErrorAlert(message: self.locationErrorMessage)
                        })
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    self.networkActivityAlert.dismiss(animated: false, completion:nil)
                }
            }
            
            task.resume()
            
        }
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

fileprivate extension MKMapView {
    func positionOnMapCoordinates(_ coordinates: CLLocationCoordinate2D) {
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        
        let region = MKCoordinateRegion(center: pin.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        setRegion(region, animated: true)
        
        addAnnotation(pin)
    }
}
