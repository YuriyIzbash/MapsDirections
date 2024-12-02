//
//  MKMapKit+Address.swift
//  MapsDirectionsGooglePlaces_LBTA
//
//  Created by YURIY IZBASH on 2. 12. 24.
//  Copyright © 2024 Brian Voong. All rights reserved.
//

import MapKit

extension MKMapItem {
    func address() -> String {
        
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
        return addrressString
    }
}
