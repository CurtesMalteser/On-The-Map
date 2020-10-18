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
        
        case udacityUserDataURL = "https://onthemap-api.udacity.com/v1/users"
        
        var url : URL? {return URL(string: self.rawValue)}
        
    }
    
    class func executeDataTask(request: URLRequest, sucessHandler: @escaping (Data) -> Void, errorHandler: @escaping (Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                errorHandler(error)
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if let newData = data { // Handle success...
                    let subData = newData.subdata(in: 5..<newData.count) /* subset response data! */
                    
                    if(response.statusCode == 200) {
                        sucessHandler(subData)
                    } else {
                        let udacityError = handleUdacityError(subData)
                        errorHandler(udacityError)
                    }
                    
                }
            }
        }
        
        task.resume()
    }
    
    class func getStudentsDataTask(url: URL, sucessHandler: @escaping ([StudentLocation]) -> Void, errorHandler: @escaping (Error?) -> Void) {
      
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let studentLocationList = try decoder.decode(StudentList.self, from: data)
                sucessHandler(studentLocationList.results)
            } catch {
                errorHandler(error)
            }
            
        }
        
        task.resume()
    }
    
    /**
     Convenience function added to generate Udacity API Error and clean the indentation to provide better code readabilty.
     This happens in cases when the API call is successfful, but the response status code isn't 200 and the message is an error.
     e.g.: The status code is 403, so the credentials are incorrect.
     */
    fileprivate class func handleUdacityError(_ subData: Data) -> Error {
        do {
            let udacityError = try JSONDecoder().decode(UdacityError.self, from: subData)
            return udacityError
        } catch {
            return error
        }
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
    
    class func deleteSessionRequest(url: URL) -> URLRequest{
        
        var request = URLRequest(url:url)
        request.httpMethod = "DELETE"
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        if let xsrfCookie  = sharedCookieStorage.cookies?.filter({$0.name == "XSRF-TOKEN"}).first {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return request
        
    }
    
}
