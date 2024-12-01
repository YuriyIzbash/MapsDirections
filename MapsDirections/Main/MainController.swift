//
//  MainController.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by Brian Voong on 11/3/19.
//  Copyright © 2019 Brian Voong. All rights reserved.
//

import UIKit
import MapKit
import LBTATools
import SwiftUI

extension MainController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        return annotationView
    }
}
                                                 

class MainController: UIViewController {
    
    let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        mapView.fillSuperview()
        
//        setupAnnotationsForMap()
        
        performLocalSearch()
        
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func setupAnnotationsForMap() {
        let annotation = MKPointAnnotation()
        annotation.title = "San Francisco"
        annotation.subtitle = "CA"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        mapView.addAnnotation(annotation)
        
        let appleCampusAnnotation = MKPointAnnotation()
        appleCampusAnnotation.title = "Apple Campus"
        appleCampusAnnotation.subtitle = "Coupertino, CA"
        appleCampusAnnotation.coordinate = CLLocationCoordinate2D(latitude: 37.3322, longitude: -122.030)
        mapView.addAnnotation(appleCampusAnnotation)
        
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    fileprivate func performLocalSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Apple"
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            // Failure
            if let err = err {
                print("Failed local search. Error:", err)
                return
            }
            // Success
            resp?.mapItems.forEach({ (mapItem) in
//                print(mapItem.placemark.subThoroughfare ?? "")
                let placemark = mapItem.placemark
                var addrressString = ""
                if placemark.subThoroughfare != nil {
                    addrressString = placemark.subThoroughfare! + " "
                }
                if placemark.thoroughfare != nil {
                    addrressString += placemark.thoroughfare! + ", "
                }
                if placemark.postalCode != nil {
                    addrressString += placemark.postalCode! + " "
                }
                if placemark.locality != nil {
                    addrressString += placemark.locality! + ", "
                }
                if placemark.administrativeArea != nil {
                    addrressString += placemark.administrativeArea! + " "
                }
                if placemark.country != nil {
                    addrressString += placemark.country!
                }
                print(addrressString)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            })
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }
    
    // SwiftUI Preview
    
    struct MainPreview: PreviewProvider {
        static var previews: some View {
            ContainerView()
                .edgesIgnoringSafeArea(.all)
        }
        
        struct ContainerView: UIViewControllerRepresentable {
            func makeUIViewController(context: Context) -> MainController {
                return MainController()
            }
            
            func updateUIViewController(_ uiViewController: MainController, context: Context) {
                
            }
            
            typealias UIViewControllerType = MainController
        }
    }
}
