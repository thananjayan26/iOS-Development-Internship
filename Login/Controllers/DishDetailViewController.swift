//
//  DishDetailViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 06/10/23.
//

import UIKit

class DishDetailViewController: UIViewController {
    
    var sheetDelegate: SheetViewDelegate?
    var endOfSheetPresentDelegate: EndOfSheetPresentDelegate?
    var dishData: OrderDish!
    var dishImageURL: String!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var dishQuantityStepperButton: QuantityStepperButton!
    @IBOutlet weak var vegImage: UIImageView!
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBAction func onDismissButtonClicked(_ sender: UIButton) {
        // To dismiss the sheet presentation
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting up the sheet views
        dishLabel.text = dishData.dishName
        priceLabel.text = "₹\(dishData.dishPrice)"
        dishImage.load(url: URL(string: dishImageURL)!)
        dishQuantityStepperButton.dishQuantity = dishData.dishQuantity
        dishQuantityStepperButton.hideQuantityButtons()
        dishQuantityStepperButton.quantityButtonDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.layoutIfNeeded()
        // Calculating height of sheet
        let descriptionSubviewFrame = descriptionLabel.frame
        let sheetHeight = descriptionSubviewFrame.origin.y + descriptionSubviewFrame.height
        sheetDelegate?.resizeSheetHeight(sheetHeight+8)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        endOfSheetPresentDelegate?.updateDishCollectionView()
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

}

extension DishDetailViewController: QuantityButtonDelegate {
    func sendUpdatedQuantity(quantity: Int) {
        dishData.dishQuantity = quantity
        updateOrDeleteOrderDish(dishData: dishData)
    }
}
