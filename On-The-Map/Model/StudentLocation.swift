//
//  StudentLocation.swift
//  On-The-Map
//
//  Created by António Bastião on 21.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    let createdAt: String
}
