//
//  BaseStudentsVC.swift
//  On-The-Map
//
//  Created by Antonio Bastião on 04.10.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class BaseStudentsVC : UIViewController {
    
    let parseStundentName: (StudentLocation) -> String = { studentLocation in
        "\(studentLocation.firstName) \(studentLocation.lastName)"
            .trimmingCharacters(in: .whitespaces)
    }
    
    var studentLocationList: [StudentLocation] = []
    
    func getStudentsList(sucessHandler: @escaping ([StudentLocation]) -> Void) {
        guard let studentsURL = UdacityAPI.Endpoint.getListOfStudentLocation.url else {
            print("Cannot create URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: studentsURL) {
            (data, response, error) in
            guard let data = data else {
                print("no data")
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let studentLocationList = try decoder.decode(StudentList.self, from: data)
                DispatchQueue.main.async {
                    self.studentLocationList = studentLocationList.results
                    
                    sucessHandler(self.studentLocationList)
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
    }
    
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
    
    func openBroweserIfValidMediaURL(_ subtitle: String) {
        guard let mediaURL: URL = URL(string: subtitle) else { return }
        
        UIApplication.shared.open(mediaURL)
    }
    
}
