//
//  CarouselCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 31/10/23.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var carouselImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setUpCell(data: CarouselData) {
        carouselImageView.image = UIImage(named: data.image)
        carouselImageView.contentMode = .scaleAspectFill
        carouselImageView.layer.cornerRadius = 20
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}
