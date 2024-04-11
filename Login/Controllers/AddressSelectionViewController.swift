//
//  AddressSelectionViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 19/10/23.
//

import UIKit
import MapKit


class AddressSelectionViewController: UIViewController {
    
    @IBOutlet weak var addressMapVIew: MKMapView!
    @IBOutlet weak var setAddressButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    var currentLocation: String?
    var addressDelegate: AddressSetDelegate? = nil
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var previousLocation: CLLocation?
    
    @IBAction func setAddressButtonClicked(_ sender: Any) {
        let address = addressLabel.text
        addressDelegate?.sendDeliveryAddress(address ?? "Address not set")
        if address != nil {
            AppCoreData.instance.setSelectedAddress(selectedAddress: address!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = .clear
        checkLocationServices()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centreMapOnUserLocation() {
        guard let location = locationManager.location?.coordinate else { return }
        let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        addressMapVIew.setRegion(region, animated: true)
        if let location = locationManager.location {
            retrieveAddressFromLocation(location: location) { addressResult in
                self.addressLabel.text = addressResult
            }
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTrackingUserLocation()
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
            @unknown default:
                fatalError()
        }
    }
    
    func startTrackingUserLocation() {
        centreMapOnUserLocation()
        addressMapVIew.showsUserLocation = true
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: addressMapVIew)
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setUpLocationManager()
            checkLocationAuthorization()
        } else {
            
        }
    }
    
    
    
    static var identifier: String {
        return String(describing: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}


extension AddressSelectionViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension AddressSelectionViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        
        guard let previousLocation = self.previousLocation else {
            return
        }
        guard center.distance(from: previousLocation) > 20 else {
            return
        }
        self.previousLocation = center
        retrieveAddressFromLocation(location: center) { resultAddress in
            self.addressLabel.text = resultAddress
        }
    }
}

func retrieveAddressFromPlacemark(placemark: CLPlacemark) -> String {
    var address = ""
    if let streetNumber = placemark.subThoroughfare {
        address += "\(streetNumber), "
    }
    if let streetName = placemark.thoroughfare {
        address += "\(streetName), "
    }
    if let localityName = placemark.locality {
        address += localityName
    }
    return address
}

