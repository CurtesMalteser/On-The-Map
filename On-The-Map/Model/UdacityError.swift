//
//  UdacityError.swift
//  On-The-Map
//
//  Created by António Bastião on 22.09.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

class UdacityError: Codable, Error {
    let status: Int
    let error: String
}
