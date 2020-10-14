//
//  LocationState.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 14.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationState {
    var address: String { get }
}

class EmptyLocationState: LocationState {
    let address: String = ""
}

class EnabledLocationState: LocationState {
    let address: String
    
    init(address: String) {
        self.address = address
    }
}

class ReadyLocationState: LocationState {
    let address: String
    let coordinates:CLLocationCoordinate2D
    
    init(address: String, coordinates:CLLocationCoordinate2D) {
        self.address = address
        self.coordinates = coordinates
    }
}
