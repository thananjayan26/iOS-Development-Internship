//
//  CarouselPageControlCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 06/11/23.
//

import UIKit

protocol UpdatePageControlDelegate {
    func updatePageControl(currentPage: Int)
}

class CarouselPageControlCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var carouselPageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(pageCount: Int) {
        carouselPageControl.numberOfPages = pageCount
        
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

}

extension CarouselPageControlCollectionViewCell: UpdatePageControlDelegate {
    func updatePageControl(currentPage: Int) {
        carouselPageControl.currentPage = currentPage
    }
}
