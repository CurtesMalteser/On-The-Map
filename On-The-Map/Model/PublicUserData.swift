//
//  PublicUserData.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 18.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

/**
 Model Used to parse the 
 */
struct PublicUserData: Codable {
    
    let firstName: String
    let lastName :String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
