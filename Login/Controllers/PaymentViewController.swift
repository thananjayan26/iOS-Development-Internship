//
//  PaymentViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 20/11/23.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBOutlet weak var applePayView: UIView!
    @IBOutlet weak var paypalView: UIView!
    @IBOutlet weak var razorPayView: UIView!
    var paymentTypeDelegate: PaymentTypeDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(goBack))
        // Do any additional setup after loading the view.
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paymentTypeSelected(sender: UIButton) {
        switch sender.tag {
        case 0:
            paymentTypeDelegate.setUpPaymentView(paymentType: PaymentType.RazorPay)
        case 1:
            paymentTypeDelegate.setUpPaymentView(paymentType: PaymentType.PayPal)
        case 2:
            paymentTypeDelegate.setUpPaymentView(paymentType: PaymentType.ApplePay)
        default:
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        let cornerRadius: CGFloat = 12
        applePayView.layer.cornerRadius = cornerRadius
        paypalView.layer.cornerRadius = cornerRadius
        razorPayView.layer.cornerRadius = cornerRadius
    }
    
    static var identifier: String {
        return String(describing: self)
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
