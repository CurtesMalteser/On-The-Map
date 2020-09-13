//
//  UdacityAPI.swift
//  On-The-Map
//
//  Created by António Bastião on 21.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    enum Endpoint: String {
        
        case getListOfStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation?limit=100?order=-updatedAt"
        
        case udacitySessionURL = "https://onthemap-api.udacity.com/v1/session"
        
        var url : URL? {return URL(string: self.rawValue)}
        
    }
}
