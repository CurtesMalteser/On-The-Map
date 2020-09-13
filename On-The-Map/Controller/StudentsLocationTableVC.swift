//
//  StudentsLocationTableVC.swift
//  On-The-Map
//
//  Created by António Bastião on 26.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class StudentsLocationTableVC:UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var studentLocationList: [StudentLocation] = []
    
    @IBOutlet var studentLocationTable: UITableView!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
         print("logout from table")
     }
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
                    
                    self.studentLocationTable.reloadData()
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return studentLocationList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        //StudentLocationCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell")
        cell?.textLabel?.text = studentLocationList[indexPath.row].firstName // todo: Add last name
        cell?.detailTextLabel?.text = studentLocationList[indexPath.row].mediaURL
      
        return cell!
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
           
       }
}
