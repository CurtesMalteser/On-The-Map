//
//  LoginVC.swift
//  On-The-Map
//
//  Created by António Bastião on 30.08.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class LoginVC:UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextFied: UITextField!
    
    @IBAction func performLogin(_ sender: Any) {
        
        guard let loginURL = UdacityAPI.Endpoint.udacitySessionURL.url else {
            print("Cannot create URL")
            return
        }
        
        guard let email = emailTextField.text else {
            // todo -> add validator and show message
            return
        }
        
        guard let password = passwordTextFied.text else {
            // todo -> show message if empty
            return
            
        }
        
        let request = initRequest(url: loginURL, username: email, password: password)
        
        executeDataTask(request: request)
    }
    
    
    private func initRequest(url: URL, username: String, password: String) -> URLRequest {
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        return request
    }
    
    private func executeDataTask(request: URLRequest) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("error \(String(describing: error))")
                return
            }
            
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                self.segueOnLoginSuccess()
            }
            
        }
        task.resume()
    }
    
    // Performs segue to Tab Controller
    private func segueOnLoginSuccess() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as? UITabBarController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
