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
    
    @IBOutlet weak var loginActivity: UIActivityIndicatorView!
    
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
        
        
        func getProfileData(_ studentSession: StudentSession) {
            UdacityAPI.onLoginSucessGetProfileDataTask(studentSession: studentSession,
                                                   sucessHandler: { studentProfile in
                                                    self.onLoginSucess(studentProfile)
                                                   },
                                                   errorHandler: {_ in self.showErrorAlert(message: self.sessionErrorMessage)})
        }
        
        let request = UdacityAPI.initLoginRequest(url: loginURL, username: email, password: password)
        
        UdacityAPI.executeDataTask(request: request,
                                   sucessHandler: { data in
                                    
                                    let decoder = JSONDecoder()
                                    
                                    do {
                                        let studentSession = try decoder.decode(StudentSession.self, from: data)
                                        
                                        getProfileData(studentSession)
                                    
                                    } catch {
                                        self.showErrorAlert(message: self.sessionErrorMessage)
                                    }
                                   },
                                   
                                   errorHandler: { error in
                                    
                                    guard let udacityError = error as? UdacityError else {
                                        self.showErrorAlert(message:  error?.localizedDescription ?? "Undefined Error")
                                        return
                                    }
                                    
                                    if(udacityError.status == 403) {
                                        self.showErrorAlert(message:  udacityError.error)
                                    } else {
                                        print("error \(udacityError.error) \(udacityError.status)")
                                        // todo -> check if there are other errors, but 400 is empty credentials and
                                        // is better avoind unecessary api call, byt checking if credentials are valid email
                                        // or pass isn't empty. Extract to funcrion
                                        self.showErrorAlert(message:  udacityError.error)
                                    }
                                    
                                    
                                   })
    }
    
    private lazy var sessionErrorMessage = """
    Invalid Session response.
    Please try login again.
    """
    
    private func showErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    private func onLoginSucess(_ studentProfile: StudentProfile) {
        DispatchQueue.main.async {
            StudentRepository.sharedInstance.studentProfile = studentProfile
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
