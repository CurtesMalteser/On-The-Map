//
//  StudentSession.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 18.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

struct StudentSession: Codable {
    let account: Account
    let session : Session
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
