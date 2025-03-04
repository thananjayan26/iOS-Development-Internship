//
//  DirectingSettingTableViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 16/10/23.
//

import UIKit

class DirectingSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconBackgroundView: UIView!
    
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
    
    func setUpDirectingCell(data: SettingsOptions) {
        iconBackgroundView.layer.cornerRadius = 5
        iconImageView.image = data.iconImageView
        titleLabel.text = data.title
        iconBackgroundView.backgroundColor = data.iconBackground
    }
    
}
