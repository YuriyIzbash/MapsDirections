//
//  MainController.swift
//  MapsDirections
//
//  Created by Yuriy Izbash on 1. 12. 24.
//  Copyright © 2024 Brian Voong. All rights reserved.
//

import UIKit
import LBTATools
import Combine


extension MainController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "id")
        annotationView.canShowCallout = true
        return annotationView
    }
}
                                                 

class MainController: UIViewController {
    
    let mapView = MKMapView()
    let searchTextField = UITextField(placeholder: "Search...")
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        view.addSubview(mapView)
        
        mapView.fillSuperview()
        view.layoutIfNeeded()
        assert(!mapView.frame.width.isNaN, "MapView width is NaN")
        assert(!mapView.frame.height.isNaN, "MapView height is NaN")
        
        setupRegionForMap()
        
//      setupAnnotationsForMap()
        
        performLocalSearch()
        
        setupSearchUI()
        
        setupLocationCarousel()
        
        locationsController.mainController = self
    }
    
    fileprivate func setupRegionForMap() {
        let centerCoordinate = CLLocationCoordinate2D(latitude: 37.7666, longitude: -122.427290)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        
        // Validate values
        assert(!centerCoordinate.latitude.isNaN, "Latitude is NaN")
        assert(!centerCoordinate.longitude.isNaN, "Longitude is NaN")
        assert(!span.latitudeDelta.isNaN, "Latitude Delta is NaN")
        assert(!span.longitudeDelta.isNaN, "Longitude Delta is NaN")
        
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
        guard let query = searchTextField.text, !query.isEmpty else {
                print("Search query is empty")
                return
            }
        
        let request = MKLocalSearch.Request()
        let searchRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
                                              span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        let refinedQuery = "\(query) near San Francisco"
        request.naturalLanguageQuery = refinedQuery
        request.region = searchRegion
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { (resp, err) in
            if let err = err {
                print("Failed local search. Error:", err)
                return
            }
            guard let results = resp?.mapItems else {
                print("No results found.")
                return
            }
            print("Number of results: \(results.count)")
            results.forEach { print($0.name ?? "No Name", $0.placemark.coordinate) }
            
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.locationsController.items.removeAll()
            results.forEach { mapItem in
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
                
                // tell my locationsCarouselController
                self.locationsController.items.append(mapItem)
            }
            
            self.locationsController.collectionView.scrollToItem(at: [0, 0], at: .centeredHorizontally, animated: true)
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
    }


    
    fileprivate func setupSearchUI() {
        
        let whiteContainer = UIView(backgroundColor: .white)
        view.addSubview(whiteContainer)
        whiteContainer.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        whiteContainer.stack(searchTextField).withMargins(.allSides(16))
        
        // listen for text changes and then perform new search
//        searchTextField.addTarget(self, action: #selector(handleSearchChanges), for: .editingChanged)
        
        // Search Throttling
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                print("Search text: \(self.searchTextField.text ?? "nil")")
                self.performLocalSearch()
            }
            .store(in: &subscriptions)
    }
    
    @objc fileprivate func handleSearchChanges() {
        performLocalSearch()
    }
    
    let locationsController = LocationCarouselController(scrollDirection: .horizontal)
    
    fileprivate func setupLocationCarousel() {
        
        let locationsView = locationsController.view!
        
        view.addSubview(locationsView)
        locationsView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
}

    // SwiftUI Preview
import SwiftUI
import MapKit

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

