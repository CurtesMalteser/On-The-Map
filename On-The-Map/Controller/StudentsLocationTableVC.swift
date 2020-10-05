//
//  StudentsLocationTableVC.swift
//  On-The-Map
//
//  Created by António Bastião on 26.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit

class StudentsLocationTableVC:BaseStudentsVC, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var studentLocationTable: UITableView!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        performLogout()
    }
    
    @IBAction func segueToAddLocation(_ sender: Any) {
        segueToAddLocationVC()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getStudentsList(sucessHandler: {_ in self.studentLocationTable.reloadData()})
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentLocationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //StudentLocationCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocationCell")
        
        let studentLocation = studentLocationList[indexPath.row]
        
        cell?.textLabel?.text = parseStundentName(studentLocation)
        
        cell?.detailTextLabel?.text = studentLocationList[indexPath.row].mediaURL
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let subtitle: String = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text else { return }
        
        openBroweserIfValidMediaURL(subtitle)
    }
    
}
