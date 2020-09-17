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
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        guard let logoutURL = UdacityAPI.Endpoint.udacitySessionURL.url else {
                   print("Cannot create URL")
                   return
               }
        
        let request = UdacityAPI.deleteSessionRequest(url: logoutURL)
        
        UdacityAPI.executeDataTask(request: request,
        sucessHandler: { data in self.onLogoutSucess(data: data) },
        errorHandler: { error in print("error \(String(describing: error))")})
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            print("Click annotation: \(annotationTitle!)")
        }
    }
    
    // MARK: todo - perform segue if logout succeeds
    private func onLogoutSucess(data: Data) {
        let newData = data.subdata(in: 5..<data.count) /* subset response data! */
        print(String(data: newData, encoding: .utf8)!)
        
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
