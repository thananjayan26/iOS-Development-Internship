//
//  dishCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 09/10/23.
//

import UIKit
import Kingfisher



class DishCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var vegImage: UIImageView!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityStepperButton: QuantityStepperButton!
    var dishTotalPriceDelegate: DishTotalPriceDelegate?
    var dishQuantity = 0
    var dishPrice = 0.0
    var dishInformation: ChineseDishModel!
    
    func setUpCell(secondData: ChineseDishModel) {
        dishInformation = secondData
        quantityStepperButton.quantityButtonDelegate = self
        quantityStepperButton.dishQuantity = dishQuantity
        quantityStepperButton.hideQuantityButtons()
        detailsButton.isHidden = false
        dishLabel.text = secondData.title
        dishPrice = 230.45
        
        priceLabel.text = "₹\(dishPrice)"
        dishImage.load(url: URL(string: secondData.image)!)
        dishImage.layer.cornerRadius = 10
        if dishLabel.countLines() > 2 {
            detailsButton.isHidden = true
        }
    }
    
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

}


extension UIImageView {
    func load(url: URL) {
        self.kf.setImage(with: url, placeholder: UIImage(named: "food placeholder"), options: [.transition(.fade(0.25))])
        self.kf.indicatorType = .activity
    }
}

protocol QuantityButtonDelegate {
    func sendUpdatedQuantity(quantity: Int)
}

extension DishCollectionViewCell: QuantityButtonDelegate {
    func sendUpdatedQuantity(quantity: Int) {
        
        dishQuantity = quantity
        dishTotalPriceDelegate?.sendOrderDetail(dishData: OrderDish(dishID: Int(dishInformation.id)!, vegetarian: true, dishName: dishInformation.title, dishQuantity: quantity, dishPrice: dishPrice))
    }
}
