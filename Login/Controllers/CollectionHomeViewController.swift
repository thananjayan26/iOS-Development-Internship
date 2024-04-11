//
//  CollectionHomeViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 09/10/23.
//

import UIKit
import CoreLocation
//import MapKit


protocol AddressSetDelegate {
    func sendDeliveryAddress(_ setAddress: String)
}

class CollectionHomeViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cartBackgroundView: UIView!
    @IBOutlet weak var cartCapsuleView: UIView!
    @IBOutlet weak var numberItemAndPriceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!

    var address: String? = nil
    let gradientMaskLayer = CAGradientLayer()
    var totalItems: Int = 0
    var totalOrderPrice: Int = 0
    var restaurantName: String?
    var selectedDishes = [0:0]
    
    var sheet: UISheetPresentationController?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let searchController = UISearchController()

    func displayCartSummary() {
        // Getting required info and displaying
        totalItems = AppCoreData.instance.getNumberOfItems() ?? 0
        if totalItems == 0 {
            cartBackgroundView.isHidden = true
        } else {
            cartBackgroundView.isHidden = false
            totalOrderPrice = AppCoreData.instance.getOrderTotal()
            numberItemAndPriceLabel.text = "\(totalItems) Item | ₹\(totalOrderPrice)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hiding necessary elements
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        address = AppCoreData.instance.getSelectedAddress()
        updateDishCollectionViewController()
    }
    
    func updateDishCollectionViewController() {
        displayCartSummary()
        updateSelectedDishesData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        gradientMaskLayer.frame = cartBackgroundView.bounds
    }
    
    func updateSelectedDishesData() {
        selectedDishes = AppCoreData.instance.getOrderDishID()
        collectionView.reloadData()
    }
    
    @objc func goToCartViewController() {
        guard let cartViewController = storyboard?.instantiateViewController(identifier: CartViewController.identifier) as? CartViewController else { return }
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cartTap = UITapGestureRecognizer(target: self, action: #selector(goToCartViewController))
        cartCapsuleView.addGestureRecognizer(cartTap)
        
        displayCartSummary()
        updateSelectedDishesData()
        /// API call to fetch data
        /*
        APICall.instance.getDishes(method: HTTPMethod.get, url: dishAPI) { result in
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                do {
                    self.requiredData = try decoder.decode([ChineseDishModel].self, from: data)
                    print(self.requiredData)
                    self.collectionView.reloadData()
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        print(requiredData)
        */
        /// End of API call
        
        // Gradient logic for cart
        restaurantName = "Liu's Waldorf"
        fromLabel.text = "From: \(restaurantName ?? "restaurant no")"
        gradientMaskLayer.frame = cartBackgroundView.bounds
        gradientMaskLayer.colors = [UIColor.clear.cgColor, UIColor.orange.cgColor, UIColor.white.cgColor]
        gradientMaskLayer.locations = [0, 0.25, 1]
        cartBackgroundView.layer.mask = gradientMaskLayer
        cartCapsuleView.layer.cornerRadius = 12

        // Setting navigation bar back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(goBack))
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.navigationBar.isTranslucent = true
        
        collectionView.reloadData()
        
        collectionView.register(DishCollectionViewCell.nib, forCellWithReuseIdentifier: DishCollectionViewCell.identifier)
        collectionView.register(AddressSectionCollectionViewCell.nib, forCellWithReuseIdentifier: AddressSectionCollectionViewCell.identifier)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


extension CollectionHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // Logic for selection of collectionView cell
        if indexPath.row == 0 {
            return
        }        
        
        let dishDetailViewController = self.storyboard?.instantiateViewController(identifier: DishDetailViewController.identifier) as? DishDetailViewController
        dishDetailViewController?.endOfSheetPresentDelegate = self
        sheet = dishDetailViewController?.sheetPresentationController
        sheet?.preferredCornerRadius = 20
        let data = requiredData[indexPath.row-1]
        let quantity: Int
        if selectedDishes[Int(data.id)!] != nil {
            quantity = selectedDishes[Int(data.id)!]!
        } else {
            quantity = 0
        }
        dishDetailViewController?.dishData = OrderDish(dishID: Int(data.id)!, vegetarian: true, dishName: data.title, dishQuantity: quantity, dishPrice: 230.45)
        
        dishDetailViewController?.sheetDelegate = self
        dishDetailViewController?.dishImageURL = data.image
        present(dishDetailViewController!, animated: true, completion: nil)
    }
}


extension CollectionHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Number of items in section
        return requiredData.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeueing and initialising cell
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddressSectionCollectionViewCell.identifier, for: indexPath) as? AddressSectionCollectionViewCell else { return UICollectionViewCell() }
            cell.navigateToMapDelegate = self
            cell.locationAddressLabel.text = address
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DishCollectionViewCell.identifier, for: indexPath) as? DishCollectionViewCell else { return UICollectionViewCell() }
        cell.dishTotalPriceDelegate = self
        let data = requiredData[indexPath.row - 1]
        if let quantity = selectedDishes[Int(data.id)!] {
            cell.dishQuantity = quantity
        } else {
            cell.dishQuantity = 0
        }
        cell.setUpCell(secondData: data)

        return cell
    }
}

 extension CollectionHomeViewController: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         // Returning dimensions of cells
         if indexPath.row == 0 {
             return CGSize(width: collectionView.bounds.width - 40, height: 178)
         }
         return CGSize(width: collectionView.bounds.width, height: 180)
     }
 }
 

extension CollectionHomeViewController: SheetViewDelegate {
    func resizeSheetHeight(_ height: CGFloat) {
        // Returning height of the detail view sheet
        sheet?.detents = [.custom { _ in
            return height
        }]
    }
}

func retrieveAddressFromLocation(location: CLLocation, updateLabel: @escaping (String) -> ()) {
    // Receiving location and obtaining address from it by reverse geocoding
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location, preferredLocale: .current) { (placemarks, error) in
        if let error = error {
            print(error)
            return
        }
        guard let placemark = placemarks?.first else {
            return
        }
        let address = retrieveAddressFromPlacemark(placemark: placemark)
        DispatchQueue.main.async {
            updateLabel(address)
        }
    }
}

extension CollectionHomeViewController: NavigateToMapDelegate {
    func notifyAddressClicked() {
        // To push the location picker view controller
        guard let addressSelectionViewController = storyboard?.instantiateViewController(withIdentifier: AddressSelectionViewController.identifier) as? AddressSelectionViewController else {
            print("Address selection failed")
            return
        }
        addressSelectionViewController.addressDelegate = self
        self.navigationController?.pushViewController(addressSelectionViewController, animated: true)
    }
}

extension CollectionHomeViewController: AddressSetDelegate {
    func sendDeliveryAddress(_ setAddress: String) {
        print("colleciton address: \(setAddress)")
    }
}

protocol DishTotalPriceDelegate {
    func sendOrderDetail(dishData: OrderDish)
}

protocol EndOfSheetPresentDelegate {
    func updateDishCollectionView()
}

extension CollectionHomeViewController: EndOfSheetPresentDelegate {
    func updateDishCollectionView() {
         updateDishCollectionViewController()
    }
}

extension CollectionHomeViewController: DishTotalPriceDelegate {
    func sendOrderDetail(dishData: OrderDish) {
        // Receiving updated dish value in cart and persisting it
        updateOrDeleteOrderDish(dishData: dishData)
        displayCartSummary()
        updateSelectedDishesData()
    }
}
