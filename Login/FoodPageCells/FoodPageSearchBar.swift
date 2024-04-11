//
//  FoodPageSearchBar.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 27/10/23.
//

import UIKit

class FoodPageSearchBar: UISearchBar {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    
    init(frame: CGRect, font: UIFont, textColor: UIColor) {
        super.init(frame: frame)
     
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
     
        searchBarStyle = .prominent
        isTranslucent = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
