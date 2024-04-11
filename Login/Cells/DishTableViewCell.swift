//
//  dishTableViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 05/10/23.
//

import UIKit

class DishTableViewCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var vegImage: UIImageView!
    @IBOutlet weak var dishLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setUpCell(data: DishModel) {
        detailsButton.isHidden = false
        vegImage.image = UIImage(named: data.veg)
        dishLabel.text = data.name
        priceLabel.text = "₹\(data.price)"
        ratingLabel.text = "★ \(data.rating)"
        reviewsLabel.text = "(\(data.reviews))"
        if let image = data.image {
            dishImage.image = UIImage(named: image)
            dishImage.layer.cornerRadius = 10
        }
        if dishLabel.countLines() > 2 {
            detailsButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
