//
//  LocationsCarouselController.swift
//  MapsDirections
//
//  Created by YURIY IZBASH on 2. 12. 24.
//  Copyright © 2024 Brian Voong. All rights reserved.
//


import UIKit
import LBTATools

class LocationCell: LBTAListCell<String> {
    override func setupViews() {
        backgroundColor = .yellow
        
        setupShadow(opacity: 0.5, radius: 12, offset: .zero, color: .black)
        layer.cornerRadius = 12
        clipsToBounds = false
    }
}

class LocationCarouselController: LBTAListController<LocationCell, String>, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: 16, bottom: 0, right: 16)
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return .init(width: view.frame.width - 64, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        
        self.items = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    }
}
