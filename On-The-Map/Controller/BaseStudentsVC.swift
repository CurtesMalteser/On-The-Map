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
    
    
        // If studentLocationList doesn't have 100 students that is the rubric requirement, it fetches the new students list from the API
        // else it uses the list in memory.
        if(StudentRepository.sharedInstance.studentLocationList.count < 100) {
        
        UdacityAPI.getStudentsDataTask(url: studentsURL,
                                       sucessHandler: {studentLocationList in
                                        DispatchQueue.main.async {
                                            StudentRepository.sharedInstance.studentLocationList = studentLocationList
                                            
                                            self.studentLocationList = StudentRepository.sharedInstance.studentLocationList
                                            
                                            sucessHandler(self.studentLocationList)
                                            
                                        }
                                       },
                                       errorHandler: { error in print("error \(String(describing: error))")})
        } else {
            self.studentLocationList = StudentRepository.sharedInstance.studentLocationList
            
            sucessHandler(self.studentLocationList)
        }
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
            StudentRepository.sharedInstance.clear()
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
