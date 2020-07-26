//
//  StudentsLocationTableVC.swift
//  On-The-Map
//
//  Created by António Bastião on 26.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class StudentsLocationTableVC:UIViewController, UITableViewDelegate, UITableViewDataSource {

    let studentList = [
        "lol",
        "ahah"
    ]
    
    override func viewWillAppear(_ animated: Bool) {
           
       }
    
    override func viewDidLoad() {
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return studentList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        //StudentLocationCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell")
        cell?.textLabel?.text = studentList[indexPath.row]
        cell?.detailTextLabel?.text = studentList[indexPath.row]
      
        return cell!
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
           
       }
}
