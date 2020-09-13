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
    
    class func executeDataTask(request: URLRequest, sucessHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                errorHandler(error)
                return
            }
            
            if let newData = data { // Handle success...
                sucessHandler(newData)
            }
        }
        
        task.resume()
    }
    
    class func initLoginRequest(url: URL, username: String, password: String) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            
            let studentLocationList = try JSONEncoder().encode(
                UdacityLogin(udacity: UdacityLoginBody(
                    username: username, password: password
                    )
                )
            )
            
            request.httpBody = studentLocationList
            
        } catch {
            print(error)
        }
        
        
        
        return request
    }
    
}
