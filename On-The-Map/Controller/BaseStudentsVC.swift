//
//  BaseStudentsVC.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 04.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class BaseStudentsVC : UIViewController {
    
    func segueToAddLocationVC() {
        self.performSegue(withIdentifier: "segueToAddLocatocation", sender: self)
    }
    
    func performLogout() {
        guard let logoutURL = UdacityAPI.Endpoint.udacitySessionURL.url else {
            print("Cannot create URL")
            return
        }
        
        let request = UdacityAPI.deleteSessionRequest(url: logoutURL)
        
        UdacityAPI.executeDataTask(request: request,
                                   sucessHandler: { data in self.onLogoutSucess() },
                                   errorHandler: { error in print("error \(String(describing: error))")})
    }
    
    private func onLogoutSucess() {
        DispatchQueue.main.async {
            self.segueOnLogoutSuccess()
        }
    }
    
    
    private func segueOnLogoutSuccess() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
}
