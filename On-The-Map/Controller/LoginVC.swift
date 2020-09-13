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
        
        let request = UdacityAPI.initLoginRequest(url: loginURL, username: email, password: password)
        
        UdacityAPI.executeDataTask(request: request,
                        sucessHandler: { data in self.onLoginSucess(data: data) },
                        errorHandler: { error in print("error \(String(describing: error))")})
    }
    
    
    
    private func onLoginSucess(data: Data) {
        let newData = data.subdata(in: 5..<data.count) /* subset response data! */
        
        print(String(data: newData, encoding: .utf8)!)
        
        DispatchQueue.main.async {
            self.segueOnLoginSuccess()
        }
        
    }
    
    // Performs segue to Tab Controller
    private func segueOnLoginSuccess() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as? UITabBarController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
