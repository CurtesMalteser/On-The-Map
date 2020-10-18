//
//  StudentSession.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 18.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

// MARK: StudentSession
/**
 Model used to parse sucessful login response.
 */
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

// MARK: PublicUserData
/**
 Model used to parse the randomized fake user data after successful login.
 */
struct PublicUserData: Codable {
    
    let firstName: String
    let lastName :String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

// MARK: StudentProfile
/**
 Model to keep in memory successful login, to be used to build POST/PUT Student Location Request.
 */
struct StudentProfile: Codable {
    let firstName: String
    let lastName :String
    let uniqueKey: String
}
