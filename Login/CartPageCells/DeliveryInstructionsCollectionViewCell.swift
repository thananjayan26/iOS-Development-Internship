//
//  DeliveryInstructionsCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 16/11/23.
//

import UIKit

class DeliveryInstructionsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var instructionLogoImageView: UIImageView!
    @IBOutlet weak var instructionBackgroundView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        instructionBackgroundView.layer.cornerRadius = 12
        // Initialization code
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setUpCell(data: InstructionData) {
        instructionLogoImageView.image = UIImage(systemName: data.instructionLogo)
        instructionLabel.text = data.instructionText
    }

}
