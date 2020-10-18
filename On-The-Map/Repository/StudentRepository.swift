//
//  StudentRepository.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 18.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import Foundation

class StudentRepository {
    
    var studentLocationList: [StudentLocation] = []
    
    static let sharedInstance = StudentRepository()

}
