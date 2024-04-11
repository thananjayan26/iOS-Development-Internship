//
//  AppearanceSegmentTableViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 17/10/23.
//

import UIKit

class AppearanceSegmentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var appearanceSegmentCell: UISegmentedControl!
    
    @IBAction func onAppearanceChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("light")
                window?.overrideUserInterfaceStyle = .light
                setAppearanceStyle(style: 0)
        case 1:
            print("dark")
                window?.overrideUserInterfaceStyle = .dark
                setAppearanceStyle(style: 1)
        case 2:
            print("high contrast")
        default:
            print("default")
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
