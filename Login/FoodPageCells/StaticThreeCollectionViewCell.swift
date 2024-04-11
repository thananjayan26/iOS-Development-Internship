//
//  StaticThreeCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 01/11/23.
//

import UIKit

class StaticThreeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellCaptionLabel: UILabel!
    
    
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
    
    func setUpCell(data: BasicData) {
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.layer.cornerRadius = 20
        cellImageView.image = UIImage(named: data.image)
        cellCaptionLabel.text = data.detail
        cellCaptionLabel.textAlignment = .center
        cellCaptionLabel.font = .systemFont(ofSize: 13)
    }
}
