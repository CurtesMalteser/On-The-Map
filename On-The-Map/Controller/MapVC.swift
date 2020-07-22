//
//  ViewController.swift
//  On-The-Map
//
//  Created by António Bastião on 21.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class MapVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let studentsURL = URL(string: UdacityAPI.getListOfStudentLocation.rawValue) else {
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
                    print(studentLocationList)
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    
}
