//
//  ViewController.swift
//  On-The-Map
//
//  Created by António Bastião on 21.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
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
                    self.addStudentsPointAnnotation(studentLocationList)
                }
            } catch {
                print(error)
            }
            
        }
        
        task.resume()
        
    }
    
    private func addStudentsPointAnnotation(_ studentLocationList: StudentList) {
        
        studentLocationList.results.forEach { studentLocation in
            
            print(studentLocation)
            
            let point = MKPointAnnotation()
            
            
            point.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                .trimmingCharacters(in: .whitespaces)
            
            point.subtitle = studentLocation.mediaURL
            
            point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            
            mapView.addAnnotation(point)
            
        }
        
    }
    
}
