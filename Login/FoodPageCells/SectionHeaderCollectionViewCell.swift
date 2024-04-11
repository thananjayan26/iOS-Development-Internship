//
//  SectionHeaderCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 27/10/23.
//

import UIKit

class SectionHeaderCollectionReusableViewCell: UICollectionReusableView {
    @IBOutlet weak var header: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func setUpCell(data: String) {
        header.text = data
    }
}
