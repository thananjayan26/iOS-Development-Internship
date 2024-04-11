//
//  HomeTabController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 12/10/23.
//

import Foundation
import UIKit
import CoreLocation

class HomeTabBarController: UITabBarController {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    let locationShortNameLabel = UILabel()
    let locationLongNameLabel = UILabel()
    private let searchController = UISearchController()
    var address: String? = nil

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkForSelectedAddress()
    }
    
    func checkForSelectedAddress() {
        // If user has selected address previously, display that. Else get current location
        // address and display
        address = AppCoreData.instance.getSelectedAddress()
        if address == nil {
            let locationManager = CLLocationManager()
            if let currentLocation = locationManager.location {
                retrieveAddressFromLocation(location: currentLocation) { addressResult in
                    self.address = addressResult
                    self.updateAddressLabels(setAddress: addressResult)
                }
            }
        } else {
            updateAddressLabels(setAddress: address!)
        }
    }
    
    func updateAddressLabels(setAddress: String) {
        // Update navigation bar labels using received address
        let splitAddress = setAddress.split(separator: ",", maxSplits: 1).map(String.init)
        locationShortNameLabel.text = splitAddress.first
        if splitAddress.count > 1 {
            locationLongNameLabel.text = splitAddress.last
        } else {
            locationLongNameLabel.text = ""
        }
    }
    
    override func viewDidLoad() {
        // Set FoodPageViewController as selected tab
        self.selectedIndex = 1
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search, Order, Enjoy, Repeat!"
        searchBar.tintColor = .orange
        _ = searchBar.searchTextField
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        // Creating One Button
        let oneButton  = UIButton(type: .custom)
        oneButton.layer.cornerRadius = 20
        oneButton.setImage(UIImage(named: "swiggyOneLogo")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal), for: .normal)
        oneButton.setImage(UIImage(named: "swiggyOneLogo")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal), for: .highlighted)
        oneButton.imageView?.contentMode = .scaleAspectFit
        oneButton.addTarget(self, action: #selector(oneButtonClicked), for: .touchUpInside)
        let oneBarButton = UIBarButtonItem(customView: oneButton)
        oneBarButton.customView?.widthAnchor.constraint(equalToConstant: 56).isActive = true
        oneBarButton.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        // Creating Profile Button
        let profileButton  = UIButton(type: .custom)
        let profileImageConfig = UIImage.SymbolConfiguration(pointSize: 32, weight: .light, scale: .default)
        profileButton.setImage(UIImage(systemName: "person.circle.fill")?.applyingSymbolConfiguration(profileImageConfig)?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal), for: .normal)
        profileButton.setImage(UIImage(systemName: "person.circle.fill")?.applyingSymbolConfiguration(profileImageConfig)?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal), for: .highlighted)
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.addTarget(self, action: #selector(goToProfilePage), for: .touchUpInside)
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        
        navigationItem.rightBarButtonItems = [profileBarButton, oneBarButton]
        
        // Creating view for location
        let locationBarView = UIView(frame: CGRect(x: 0, y: 0, width: (navigationController?.navigationBar.frame.width)!/2, height: 40))
        locationBarView.translatesAutoresizingMaskIntoConstraints = false
        
        let locationBarButton = UIButton(type: .custom)
        locationBarButton.setTitle("", for: .normal)
        locationBarButton.addTarget(self, action: #selector(locationButtonClicked), for: .touchUpInside)
        locationBarButton.translatesAutoresizingMaskIntoConstraints = false
        
        let locationSymbolImageView = UIImageView()
        
        locationSymbolImageView.image = UIImage(systemName: "location.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        locationSymbolImageView.translatesAutoresizingMaskIntoConstraints = false
        
        locationShortNameLabel.text = "Set Address"//"Tidel Park"
        locationShortNameLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        locationShortNameLabel.textColor = .appSecondaryColour
        locationShortNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let chevronImageView = UIImageView()
        chevronImageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        locationLongNameLabel.text = ""
        locationLongNameLabel.font = .systemFont(ofSize: 11, weight: .light)
        locationLongNameLabel.textColor = .appTertiaryColour
        locationLongNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        locationBarView.addSubview(locationSymbolImageView)
        locationBarView.addSubview(locationShortNameLabel)
        locationBarView.addSubview(chevronImageView)
        locationBarView.addSubview(locationLongNameLabel)
        locationBarView.addSubview(locationBarButton)
        
        locationBarView.translatesAutoresizingMaskIntoConstraints = false
        
        // Setting constraints
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(locationSymbolImageView.leadingAnchor.constraint(equalTo: locationBarView.safeAreaLayoutGuide.leadingAnchor, constant: 0))
        constraints.append(locationSymbolImageView.topAnchor.constraint(equalTo: locationBarView.safeAreaLayoutGuide.topAnchor, constant: 0))
        constraints.append(locationSymbolImageView.heightAnchor.constraint(equalToConstant: 18))
        constraints.append(locationSymbolImageView.widthAnchor.constraint(equalToConstant: 20))
        
        constraints.append(locationShortNameLabel.leadingAnchor.constraint(equalTo: locationSymbolImageView.safeAreaLayoutGuide.trailingAnchor, constant: 2))
        constraints.append(locationShortNameLabel.topAnchor.constraint(equalTo: locationSymbolImageView.topAnchor))
        constraints.append(locationShortNameLabel.heightAnchor.constraint(equalToConstant: 20))
        
        constraints.append(chevronImageView.leadingAnchor.constraint(equalTo: locationShortNameLabel.safeAreaLayoutGuide.trailingAnchor, constant: 3))
        constraints.append(chevronImageView.topAnchor.constraint(equalTo: locationShortNameLabel.topAnchor, constant: 2))
        constraints.append(chevronImageView.heightAnchor.constraint(equalToConstant: 18))
        
        constraints.append(locationLongNameLabel.leadingAnchor.constraint(equalTo: locationSymbolImageView.leadingAnchor))
        constraints.append(locationLongNameLabel.topAnchor.constraint(equalTo: locationSymbolImageView.bottomAnchor, constant: 4))
        constraints.append(locationLongNameLabel.heightAnchor.constraint(equalToConstant: 14))
        constraints.append(locationLongNameLabel.trailingAnchor.constraint(equalTo: locationBarView.trailingAnchor, constant: -6))
        
        constraints.append(locationBarButton.leadingAnchor.constraint(equalTo: locationBarView.leadingAnchor))
        constraints.append(locationBarButton.topAnchor.constraint(equalTo: locationBarView.topAnchor))
        constraints.append(locationBarButton.bottomAnchor.constraint(equalTo: locationBarView.bottomAnchor))
        constraints.append(locationBarButton.trailingAnchor.constraint(equalTo: locationBarView.trailingAnchor))
        
        NSLayoutConstraint.activate(constraints)
        
        
        // Clickable button for address
        let locationBarWholeButton = UIBarButtonItem(customView: locationBarView)
        locationBarWholeButton.customView?.widthAnchor.constraint(equalToConstant: 215).isActive = true
        locationBarWholeButton.customView?.heightAnchor.constraint(equalToConstant: 36).isActive = true
        navigationItem.leftBarButtonItem = locationBarWholeButton
    }
    
    @objc func oneButtonClicked() {
        print("one button clkcked")
    }
    
    @objc func locationButtonClicked() {
        print("location button clkcked")
        // Go to address selection view controller
        guard let addressSelectionViewController = storyboard?.instantiateViewController(withIdentifier: AddressSelectionViewController.identifier) as? AddressSelectionViewController else {
            print("Address selection failed")
            return
        }
        self.navigationController?.pushViewController(addressSelectionViewController, animated: true)
    }
    
    @objc func goToProfilePage() {
        print("profile pic clicked")
        // Go to profile view controller
        guard let profileViewController = storyboard?.instantiateViewController(withIdentifier: ProfileViewController.identifier) else {
            print("Profile view controller failed")
            return
        }
        navigationController?.pushViewController(profileViewController, animated: true)
    }
}

