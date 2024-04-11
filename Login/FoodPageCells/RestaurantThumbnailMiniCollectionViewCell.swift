//
//  RestaurantThumbnailMiniCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 01/11/23.
//

import UIKit

class RestaurantThumbnailMiniCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantOffersLabel: UILabel!
    @IBOutlet weak var swiggyOneImageView: UIImageView!
    @IBOutlet weak var restaurantLikedImageView: UIImageView!
    @IBOutlet weak var ratingAndTimeLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
  
    static var identifier: String {
        return String(describing: self)
    }
    func configureToMega() {
        swiggyOneImageView.isHidden = true
        restaurantNameLabel.font = .systemFont(ofSize: 15, weight: .bold)
        ratingAndTimeLabel.font = .systemFont(ofSize: 13, weight: .regular)
        cuisineLabel.font = .systemFont(ofSize: 13, weight: .regular)
    }
    
    func setUpCell(data: RestaurantData) {
        swiggyOneImageView.isHidden = false
        restaurantLikedImageView.tintColor = .white
        restaurantImageView.contentMode = .scaleAspectFill
        restaurantImageView.image = UIImage(named: data.image)
        restaurantNameLabel.text = data.name
        restaurantImageView.layer.cornerRadius = 16
        swiggyOneImageView.backgroundColor = .white
        swiggyOneImageView.image = UIImage(named: "swiggyOneLogo")
        swiggyOneImageView.layer.cornerRadius = swiggyOneImageView.frame.height/2
        swiggyOneImageView.layer.borderColor = UIColor.systemOrange.cgColor
        swiggyOneImageView.layer.borderWidth = 1
        if data.offers.isEmpty {
            restaurantOffersLabel.isHidden = true
        } else {
            restaurantOffersLabel.text = data.offers.first
        }
        var ratingAndTime = "\(data.rating) · \(data.time) mins"
        ratingAndTimeLabel.text = ratingAndTime
        cuisineLabel.text = data.cuisine
    }

}
