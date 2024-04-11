//
//  HomeViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 05/10/23.
//

import UIKit

protocol SheetViewDelegate {
    func resizeSheetHeight(_ height: CGFloat)
}

var data: [DishModel] = [
    DishModel(veg: "veg", name: "T-fal Initiatives Nonstick Cookware Set 18 Piece Pots and Pans, Dishwasher Safe Black", price: 260, rating: 4.4, reviews: 239, image: "food image", description: "This is the description of the dish. This is the description of the dish. This is the description of the dish. This is the description of the dish."),
    DishModel(veg: "nonVeg", name: "T-fal Initiatives Nonstick Cookware Set 18 Piece Pots and Pans, Dishwasher Safe Black", price: 460, rating: 4.5, reviews: 1239, image: "non veg", description: " Yes Yes Yes Yes This is the description of the dish. This is the description of the dish. This is the description of the dish. This is the description of the dish. Yes Yes Yes Yes This is the description of the dish. This is the description of the dish. This is the description of the dish. \n\n\nThis is the description of the dish. ")]


// File not used in project
class HomeViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    
    var sheet: UISheetPresentationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.register(DishTableViewCell.nib, forCellReuseIdentifier: DishTableViewCell.identifier)
        homeTableView.sectionHeaderTopPadding = 3
        homeTableView.sectionFooterHeight = 26
        // Do any additional setup after loading the view.
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

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped me \(indexPath)")
        let dishDetailViewController = self.storyboard?.instantiateViewController(identifier: "DishDetailViewController") as? DishDetailViewController
        sheet = dishDetailViewController?.sheetPresentationController
        
        dishDetailViewController?.sheetDelegate = self
        sheet?.detents = [.medium()]
        sheet?.preferredCornerRadius = 30
        //dishDetailViewController?.dataDish = data[indexPath.row%2]
        
        present(dishDetailViewController!, animated: true, completion: nil)
        //navigationController?.popViewController(animated: true)
        return
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return data[section].count
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: DishTableViewCell.identifier, for: indexPath) as? DishTableViewCell {
            cell.setUpCell(data: data[indexPath.row%2])
            return cell
        }
        return UITableViewCell()
    }
}


extension UILabel {
  func countLines() -> Int {
    guard let myText = self.text as NSString? else {
      return 0
    }
    // Call self.layoutIfNeeded() if your view uses auto layout
    let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
    let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
    print("\(CGFloat(labelSize.height)) and \(self.font.lineHeight)")
    return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
  }
}


extension HomeViewController: SheetViewDelegate {
    func resizeSheetHeight(_ height: CGFloat) {
        sheet?.detents = [.custom { _ in
            return height
        }]
    }
}
