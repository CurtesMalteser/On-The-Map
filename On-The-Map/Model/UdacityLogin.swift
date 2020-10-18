//
//  UdacityLogin.swift
//  On-The-Map
//
//  Created by António Bastião on 13.09.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

struct UdacityLogin: Codable {
    let udacity: UdacityLoginBody
}

struct UdacityLoginBody: Codable {
    let username: String
    let password :String
}
