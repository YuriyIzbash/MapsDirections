//
//  LocationsCarouselController.swift
//  MapsDirections
//
//  Created by YURIY IZBASH on 2. 12. 24.
//  Copyright © 2024 Brian Voong. All rights reserved.
//


import UIKit
import LBTATools
import MapKit

class LocationCell: LBTAListCell<MKMapItem> {
    
    override var item: MKMapItem! {
        didSet {
            label.text = item.name
            addressLabel.text = item.address()
            item.placemark.coordinate.longitude
            item.placemark.coordinate.latitude
        }
    }
    
    let label = UILabel(text: "Location", font: .boldSystemFont(ofSize: 16))
    let addressLabel = UILabel(text: "Address", font: .systemFont(ofSize: 14), numberOfLines: 0)
    
    override func setupViews() {
        backgroundColor = .white
        
        setupShadow(opacity: 0.5, radius: 8, offset: .zero, color: .black)
        layer.cornerRadius = 8
        
        stack(label, addressLabel).withMargins(.allSides(16))
    }
}

class LocationCarouselController: LBTAListController<LocationCell, MKMapItem> {
    
    weak var mainController: MainController?
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(self.items[indexPath.item].name)
        
        let annotations = mainController?.mapView.annotations
        
        annotations?.forEach({ (annotation) in
            
            if annotation.title == self.items[indexPath.item].name {
                mainController?.mapView.selectAnnotation(annotation, animated: true)
            }
        })
        guard collectionView.numberOfSections > 0,
              collectionView.numberOfItems(inSection: 0) > 0 else {
            print("No items to scroll to in the collection view.")
            return
        }

        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        
//        let placemark = MKPlacemark(coordinate: .init(latitude: 10, longitude: 55))
//        let dummyMapItem = MKMapItem(placemark: placemark)
//        dummyMapItem.name = "Dummy Location"
//        self.items = [dummyMapItem]
//        self.items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }
}

extension LocationCarouselController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
