//
//  QuickPicksCapsuleCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 02/11/23.
//

import UIKit

class QuickPicksCapsuleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var capsuleLabel: UILabel!
    @IBOutlet weak var capsuleBackgroundView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(data: BasicData) {
        capsuleLabel.text = data.detail
        capsuleBackgroundView.layer.backgroundColor = UIColor.clear.cgColor
        capsuleLabel.textColor = .appSecondaryColour
        capsuleBackgroundView.layer.borderWidth = 1
        capsuleBackgroundView.layer.borderColor = UIColor.appTertiaryColour.cgColor
        capsuleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        capsuleLabel.layer.masksToBounds = true
    }
    
    func updateToSelectedState() {
        capsuleBackgroundView.backgroundColor = .appSecondaryColour
        capsuleLabel.textColor = .appPrimaryColour
        capsuleBackgroundView.layer.borderColor = UIColor.appSecondaryColour.cgColor
    }
    
    func updateToDeselectedState() {
        capsuleBackgroundView.backgroundColor = .clear
        capsuleLabel.textColor = .appSecondaryColour
        capsuleBackgroundView.layer.borderColor = UIColor.appTertiaryColour.cgColor
    }
    
    override func layoutSubviews() {
        capsuleBackgroundView.layer.cornerRadius = capsuleBackgroundView.bounds.height/2
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
