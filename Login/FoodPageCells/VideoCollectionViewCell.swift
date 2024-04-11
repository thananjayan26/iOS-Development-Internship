//
//  VideoCollectionViewCell.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 27/10/23.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var videoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUpCell(data: String) {
        videoImageView.image = UIImage(named: data)
        videoImageView.contentMode = .scaleAspectFill
        videoImageView.layer.cornerRadius = 10
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
