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
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func performLogin(_ sender: Any) {
        
        guard let loginURL = UdacityAPI.Endpoint.udacitySessionURL.url else {
            print("Cannot create URL")
            return
        }

        self.setLogginIn(true)

        guard let email = emailTextField.text else {
            return
        }

        guard let password = passwordTextFied.text else {
            return
        }

        func getProfileData(_ studentSession: StudentSession) {
            UdacityAPI.onLoginSucessGetProfileDataTask(studentSession: studentSession,
                                                   successHandler: { studentProfile in
                                                    self.onLoginSucess(studentProfile)
                                                   },
                                                   errorHandler: {_ in self.showErrorAlert(message: self.sessionErrorMessage)})
        }

        let request = UdacityAPI.initLoginRequest(url: loginURL, username: email, password: password)

        UdacityAPI.executeDataTask(request: request,
                                   successHandler: { data in

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
                                        self.showErrorAlert(message:  udacityError.error)
                                    }


                                   })
    }
    
    private lazy var sessionErrorMessage = """
    Invalid Session response.
    Please try login again.
    """
    
    private func showErrorAlert(message: String) {
        showErrorAlert(message: message, callback: { [self] in setLogginIn(false)})
    }
    
    
    private func onLoginSucess(_ studentProfile: StudentProfile) {
        DispatchQueue.main.async {
            StudentRepository.sharedInstance.studentProfile = studentProfile
            self.setLogginIn(false)
            self.segueOnLoginSuccess()
        }
    }
    
    // Performs segue to Tab Controller
    private func segueOnLoginSuccess() {
        let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabBarController") as? UITabBarController
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func setLogginIn(_ loggingIn: Bool) {
        if loggingIn {
            
            loginActivity.startAnimating()
        } else {
            loginActivity.stopAnimating()
        }
        
        emailTextField.isEnabled = !loggingIn
        passwordTextFied.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
}
