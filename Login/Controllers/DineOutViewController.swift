//
//  DineOutViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 30/10/23.
//

import UIKit

class DineOutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        self.tabBarItem = UITabBarItem(title: "Check", image: UIImage(named: "SwiggySelectedLogo")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "SwiggyDeselectedLogo")?.withRenderingMode(.alwaysOriginal))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
