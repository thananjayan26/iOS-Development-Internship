//
//  SettingsProfileTableViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 16/10/23.
//

import UIKit
import GoogleSignIn
import Kingfisher

class SettingsProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpProfileCell() {
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        if let profileData = AppCoreData.instance.getUserInformation() {
            emailLabel.text = profileData.userEmail
            nameLabel.text = profileData.userName
            if profileData.userImageData != nil {
                profileImageView.image = UIImage(data: profileData.userImageData!)
            }
        }
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
