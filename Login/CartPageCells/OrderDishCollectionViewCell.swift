//
//  OrderDishCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 14/11/23.
//

import UIKit

class OrderDishCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishPriceLabel: UILabel!
    @IBOutlet weak var dishQuantityStepperButton: QuantityStepperButton!
    @IBOutlet weak var dishVegImageView: UIImageView!
    var orderUpdateLabelsDelegate: OrderUpdatedDelegate!
    var dishData: OrderDish?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setUpCell(data: OrderDish) {
        print(data)
        dishData = data
        dishQuantityStepperButton.quantityButtonDelegate = self
        dishNameLabel.text = data.dishName
        dishPriceLabel.text = "₹\(Int(data.dishPrice.rounded()))"
        dishQuantityStepperButton.dishQuantity = data.dishQuantity
        dishQuantityStepperButton.hideQuantityButtons()
    }

}

func updateOrDeleteOrderDish(dishData: OrderDish?) {
    guard let dishData = dishData else { return }
    if AppCoreData.instance.checkIfDishInOrder(dishID: dishData.dishID) {
        if dishData.dishQuantity == 0 {
            AppCoreData.instance.deleteSpecificOrderDetail(dishID: dishData.dishID)
        } else {
            AppCoreData.instance.updateDishDetailOrder(dishID: dishData.dishID, dishQuantity: dishData.dishQuantity)
            print(AppCoreData.instance.getOrderDetails())
        }
    } else {
        AppCoreData.instance.addDishToOrder(dishId: dishData.dishID, dishName: dishData.dishName, dishQuantity: dishData.dishQuantity, dishPrice: dishData.dishPrice)
    }
}

extension OrderDishCollectionViewCell: QuantityButtonDelegate {
    func sendUpdatedQuantity(quantity: Int) {
        print(quantity)
        dishData?.dishQuantity = quantity
        updateOrDeleteOrderDish(dishData: dishData)
        orderUpdateLabelsDelegate.orderUpdateLabels()
    }
    
    
}
