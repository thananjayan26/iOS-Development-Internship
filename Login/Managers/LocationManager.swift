//
//  LocationManager.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 19/10/23.
//

import Foundation
import CoreLocation
/*
class LocationManager:  NSObject, CLLocationManagerDelegate {
    
    //private init() {}
    static let shared = LocationManager()
    
    let manager = CLLocationManager()
    
    var completion: ((CLLocation) -> Void)?
    
    public func getUserLocation(completion: @escaping (CLLocation) -> Void) {
        self.completion = completion
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        completion?(location)
        manager.stopUpdatingLocation()
    }
    
    public func getLocationName(location: CLLocation, completion: @escaping ((String?) -> Void)) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { placemarks, error in
            guard let place = placemarks?.first, error == nil else {
                completion(nil)
                return
            }
            print("place subloc \(place.subLocality)")
            print("place name \(place.name)")
            print("place subadmin \(place.subAdministrativeArea)")
            print("place street\(place.thoroughfare)")
            print("place sublocal \(place.subLocality)")
            
            var name = ""
            if let locality = place.locality {
                name += "\(locality)"
            }
            if let region = place.administrativeArea {
                name += ", \(region)"
            }
            completion(name)
        }
    }
}
*/
