//
//  DishNavigationController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 19/10/23.
//

import Foundation
import UIKit


class DishNavigationController: UINavigationController {
    
    @IBOutlet weak var dishTabBarItem: UITabBarItem!
    
    static var identifier: String {
        return String(describing: self)
    }
}
