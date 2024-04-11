//
//  SeactionHeaderCollectionReusableView.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 31/10/23.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var header: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(data: String) {
        header.text = data
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
