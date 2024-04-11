//
//  AddressSectionCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 19/10/23.
//

import UIKit

protocol NavigateToMapDelegate {
    func notifyAddressClicked()
}

class AddressSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var locationAddressLabel: UILabel!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var outletAddressDropIconImageView: UIImageView!
    @IBOutlet weak var deliveryAddressDropIconImageView: UIImageView!
    @IBOutlet weak var favouriteImageView: UIImageView!
    
    @IBOutlet weak var lineImageView: UIImageView!
    var navigateToMapDelegate: NavigateToMapDelegate?
    var favourite = false

    override func awakeFromNib() {
        super.awakeFromNib()
        let tapFav = UITapGestureRecognizer(target: self, action: #selector(favouriteClicked))
        favouriteImageView.addGestureRecognizer(tapFav)
        self.cardView.layer.cornerRadius = 12
        let tap = UITapGestureRecognizer(target: self, action: #selector(locationAddressLabelClicked))
        locationAddressLabel.addGestureRecognizer(tap)
        outletAddressDropIconImageView.tintColor = .orange
        deliveryAddressDropIconImageView.tintColor = .orange
    }
    
    @objc func favouriteClicked() {
        favourite.toggle()
        if favourite {
            favouriteImageView.image = UIImage(systemName: "heart.fill")?.withTintColor(.systemPink, renderingMode: .alwaysOriginal)
        } else {
            favouriteImageView.image = UIImage(systemName: "heart")
        }
    }
    
    @IBAction func locationAddressLabelClicked(sender: UITapGestureRecognizer) {
        print("tap working")
        navigateToMapDelegate?.notifyAddressClicked()
        return
    }

    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
