//
//  ViewController.swift
//  On-The-Map
//
//  Created by António Bastião on 21.07.20.
//  Copyright © 2020 António Bastião. All rights reserved.
//

import UIKit
import MapKit

class MapVC: BaseStudentsVC, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        performLogout()
    }
    
    @IBAction func segueToAddLocation(_ sender: Any) {
        segueToAddLocationVC()
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
        
        let anotations: [MKAnnotation] = studentLocationList.results.map { studentLocation in
            
            print(studentLocation)
            
            let point = MKPointAnnotation()
            
            point.title = "\(studentLocation.firstName) \(studentLocation.lastName)"
                .trimmingCharacters(in: .whitespaces)
            
            point.subtitle = studentLocation.mediaURL
            
            point.coordinate = CLLocationCoordinate2D(latitude: studentLocation.latitude, longitude: studentLocation.longitude)
            
            return point
        }
        
        mapView.addAnnotations(anotations)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .infoLight)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let subtitle: String = view.annotation?.subtitle as? String else { return }
        
        guard let mediaURL: URL = URL(string: subtitle) else { return }
        
        UIApplication.shared.open(mediaURL)
        
    }
    

    
}
