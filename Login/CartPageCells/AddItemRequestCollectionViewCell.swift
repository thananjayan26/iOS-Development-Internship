//
//  AddItemRequestCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 14/11/23.
//

import UIKit

class AddItemRequestCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    
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
    
    func setUpCell(title: String) {
        titleLabel.text = title
    }
}
