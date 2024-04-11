//
//  CartViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 14/11/23.
//

import UIKit
import Razorpay

class CartViewController: UIViewController{
    
    @IBOutlet weak var timeAndAddressView: UIView!
    @IBOutlet weak var discountInfoView: UIView!
    @IBOutlet weak var cartScrollView: UIScrollView!
    @IBOutlet weak var orderDishesCollectionView: UICollectionView!
    @IBOutlet weak var deliveryInstructionsCollectionView: UICollectionView!
    @IBOutlet weak var orderDishesCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var offerBenefitView: UIView!
    @IBOutlet weak var oneBenefitView: UIView!
    @IBOutlet weak var billView: UIView!
    @IBOutlet weak var reviewOrderInfoView: UIView!
    @IBOutlet weak var cartPageScrollViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cartScrollableView: UIView!
    @IBOutlet weak var paymentBottomView: UIView!
    @IBOutlet weak var paymentLogoImageView: UIImageView!
    @IBOutlet weak var slideToPayLabel: UILabel!
    @IBOutlet weak var paymentSlider: UISlider!
    @IBOutlet weak var toPayLabel: UILabel!
    @IBOutlet weak var gstTotalLabel: UILabel!
    @IBOutlet weak var itemTotalLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var changePaymentLabel: UILabel!
    @IBOutlet weak var paymentLogoBackgroundView: UIView!
    @IBOutlet weak var paymentTypeTitleLabel: UILabel!
    var paymentGateway: PaymentType!
    var orderDetails: [OrderDish]! = []
    var razorpay: RazorpayCheckout!
    var totalToPay: Int!
    
    func goToGateways() {
        switch paymentGateway {
        case .RazorPay:
            performRazorPay()
        case .ApplePay:
            paymentSuccessSequence()
        case .PayPal:
            paymentSuccessSequence()
        default:
            paymentSuccessSequence()
        }
    }
    
    func performRazorPay() {
        razorpay = RazorpayCheckout.initWithKey("rzp_test_5ho8pYoIS4xd86", andDelegate: self)
        self.showRazorPaymentForm()
    }
    
    
    @objc func goToPaymentPage() {
        guard let paymentViewController = storyboard?.instantiateViewController(withIdentifier: PaymentViewController.identifier) as? PaymentViewController else { return }
        navigationController?.pushViewController(paymentViewController, animated: true)
        paymentViewController.paymentTypeDelegate = self
    }
    
    @IBAction func sliderValueThumbImage(_ sender: Any) {
        if paymentSlider.value >= paymentSlider.maximumValue/1.5 {
            let image = UIImage(named: "sliderImageDone")
            let targetSize = CGSize(width: 46, height: 46)
            let scaledImage = image!.scalePreservingAspectRatio(targetSize: targetSize)
            paymentSlider.setThumbImage(scaledImage, for: .normal)
            paymentSlider.setThumbImage(scaledImage, for: .highlighted)
        } else {
            let image = UIImage(named: "sliderImage")!
            let targetSize = CGSize(width: 46, height: 46)
            let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
            paymentSlider.setThumbImage(scaledImage, for: .normal)
            paymentSlider.setThumbImage(scaledImage, for: .highlighted)
        }
    }
    
    @IBAction func sliderValueChanged(_ sender: Any) {
        print(paymentSlider.value)
        if paymentSlider.value >= paymentSlider.maximumValue/1.5 {
            paymentSlider.setValue(paymentSlider.maximumValue, animated: true)
            goToGateways()
        } else {
            paymentSlider.setValue(paymentSlider.minimumValue, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backgroundColor = .appQuartColour
        
        orderDetails = AppCoreData.instance.getOrderDetails()
        addressLabel.text = "| \(AppCoreData.instance.getSelectedAddress()!)"
        paymentSlider.value = paymentSlider.minimumValue
        let image = UIImage(named: "sliderImage")!
        let targetSize = CGSize(width: 46, height: 46)
        let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
        paymentSlider.setThumbImage(scaledImage, for: .normal)
        paymentSlider.setThumbImage(scaledImage, for: .highlighted)
        
        navigationController?.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.backgroundColor = .clear
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    func updatePricesLabels() {
        let total = AppCoreData.instance.getOrderTotal()
        itemTotalLabel.text = "₹\(total)"
        let gstAmount = Double(total)*0.05 + 0.54
        gstTotalLabel.text = "₹\(gstAmount.round(to: 2))"
        totalToPay = total + 3 + Int(gstAmount.rounded())
        toPayLabel.text = "₹\(totalToPay!)"
        slideToPayLabel.text = "Slide to pay | ₹\(totalToPay!)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentGateway = .RazorPay
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToPaymentPage))
        changePaymentLabel.addGestureRecognizer(tap)
        
        orderDetails = AppCoreData.instance.getOrderDetails()
        paymentSlider.setValue(0, animated: false)

        let image = UIImage(named: "sliderImage")!
        let targetSize = CGSize(width: 46, height: 46)
        let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
        paymentSlider.setThumbImage(scaledImage, for: .normal)
        paymentSlider.setThumbImage(scaledImage, for: .highlighted)
        slideToPayLabel.layer.cornerRadius = slideToPayLabel.frame.height/2
        slideToPayLabel.layer.masksToBounds = true
        
        offerBenefitView.layer.cornerRadius = 16
        oneBenefitView.layer.cornerRadius = 16
        billView.layer.cornerRadius = 16
        reviewOrderInfoView.layer.cornerRadius = 16
        paymentBottomView.layer.cornerRadius = 20
        paymentLogoBackgroundView.layer.cornerRadius = 8
        paymentLogoBackgroundView.layer.borderColor = UIColor.appTertiaryColour.cgColor
        paymentLogoBackgroundView.layer.borderWidth = 0.5

        orderDishesCollectionView.register(OrderDishCollectionViewCell.nib, forCellWithReuseIdentifier: OrderDishCollectionViewCell.identifier)
        orderDishesCollectionView.register(AddItemRequestCollectionViewCell.nib, forCellWithReuseIdentifier: AddItemRequestCollectionViewCell.identifier)
        deliveryInstructionsCollectionView.register(DeliveryInstructionsCollectionViewCell.nib, forCellWithReuseIdentifier: DeliveryInstructionsCollectionViewCell.identifier)

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward")?.withTintColor(.appTertiaryColour, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(goBack))
        navigationController?.hidesBarsOnSwipe = false

        timeAndAddressView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        timeAndAddressView.layer.cornerRadius = 24
        
        discountInfoView.layer.cornerRadius = 16
        discountInfoView.layer.borderWidth = 1
        discountInfoView.layer.borderColor = UIColor.cartGreen.cgColor
        
        orderDishesCollectionViewHeightConstraint.constant = orderDishesCollectionView.collectionViewLayout.collectionViewContentSize.height + 8
        orderDishesCollectionView.layoutIfNeeded()
        // Do any additional setup after loading the view.
        
        orderDishesCollectionView.collectionViewLayout.invalidateLayout()
        print(cartScrollableView.frame.height)
        orderDishesCollectionView.layer.cornerRadius = 16
        
        updatePricesLabels()
    }
    
    func updateOrderDishCollectionView() {
        orderDetails = AppCoreData.instance.getOrderDetails()
        if orderDetails.count == 0 {
            navigationController?.popViewController(animated: true)
        }
        orderDishesCollectionView.reloadData()
        orderDishesCollectionViewHeightConstraint.constant = orderDishesCollectionView.collectionViewLayout.collectionViewContentSize.height + 8
        orderDishesCollectionView.layoutIfNeeded()
    }
    
    func paymentFailureSuccess() {
        let failureAlert = UIAlertController(title: "Order Failure", message: "Your payment was unsuccessful", preferredStyle: .alert)
        failureAlert.addAction(UIAlertAction(title: "Close", style: .default))
        present(failureAlert, animated: true, completion: nil)
    }
    
    func paymentSuccessSequence() {
        guard let homeTabBarController = storyboard?.instantiateViewController(withIdentifier: HomeTabBarController.identifier) as? HomeTabBarController else {
            print("Home tab bar controller failed")
            return
        }
        AppCoreData.instance.deleteOrderDetails()
        navigationController?.navigationController?.setViewControllers([homeTabBarController], animated: true)
        let successAlert = UIAlertController(title: "Order Placed", message: "Your payment was successful", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Close", style: .default))
        present(successAlert, animated: true, completion: nil)
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


extension CartViewController: UICollectionViewDelegate {
    
}

extension CartViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(orderDetails.count)
        if collectionView == orderDishesCollectionView {
            return orderDetails.count + 2
        } else {
            return deliveryInstructions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == orderDishesCollectionView {
            if indexPath.item > orderDetails.count - 1 {
                guard let cell = orderDishesCollectionView.dequeueReusableCell(withReuseIdentifier: AddItemRequestCollectionViewCell.identifier, for: indexPath) as? AddItemRequestCollectionViewCell else { return UICollectionViewCell() }
                if indexPath.item == orderDetails.count {
                    cell.setUpCell(title: "Add more items")
                } else {
                    cell.setUpCell(title: "Add cooking requests")
                }
                return cell
            } else {
                guard let cell = orderDishesCollectionView.dequeueReusableCell(withReuseIdentifier: OrderDishCollectionViewCell.identifier, for: indexPath) as? OrderDishCollectionViewCell else { return UICollectionViewCell() }
                cell.orderUpdateLabelsDelegate = self
                cell.setUpCell(data: orderDetails[indexPath.item])
                return cell
            }
        } else {
            guard let cell = deliveryInstructionsCollectionView.dequeueReusableCell(withReuseIdentifier: DeliveryInstructionsCollectionViewCell.identifier, for: indexPath) as? DeliveryInstructionsCollectionViewCell else { return UICollectionViewCell() }
            cell.setUpCell(data: deliveryInstructions[indexPath.item])
            return cell
        }
    }
}

extension CartViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == orderDishesCollectionView {
            return CGSize(width: orderDishesCollectionView.bounds.width, height: 44)
        } else {
            return CGSize(width: 88, height: 88)
        }
    }
}

protocol OrderUpdatedDelegate {
    func orderUpdateLabels()
}

protocol PaymentTypeDelegate {
    func setUpPaymentView(paymentType: PaymentType)
}

extension CartViewController: OrderUpdatedDelegate {
    func orderUpdateLabels() {
        updatePricesLabels()
        updateOrderDishCollectionView()
    }
}

extension CartViewController: PaymentTypeDelegate {
    func setUpPaymentView(paymentType: PaymentType) {
        paymentGateway = paymentType
        let paymentTitleString: String
        let paymentLogo: String
        switch paymentType {
        case .ApplePay:
            paymentLogo = "applePay"
            paymentTitleString = "Apple Pay"
        case .RazorPay:
            paymentLogo = "razorPay"
            paymentTitleString = "RazorPay"
        case .PayPal:
            paymentLogo = "paypal"
            paymentTitleString = "PayPal"
        }
        print(paymentLogo)
        print(paymentTitleString)
        paymentLogoImageView.image = UIImage(named: paymentLogo)
        paymentTypeTitleLabel.text = paymentTitleString
    }
}

extension CartViewController: RazorpayPaymentCompletionProtocol {
    func onPaymentError(_ code: Int32, description str: String) {
        print("error: ", code, str)
        paymentFailureSuccess()
    }

    func onPaymentSuccess(_ payment_id: String) {
        print("success: ", payment_id)
        paymentSuccessSequence()
    }
    
    
    internal func showRazorPaymentForm(){
        let options: [String:Any] = [
                    "amount": "\(totalToPay*100)", // This is in currency subunits. 100 = 100 paise= INR 1.
                    "currency": "INR", // We support more that 92 international currencies.
                    "description": "Food order",
                    "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Good_Food_Display_-_NCI_Visuals_Online.jpg/800px-Good_Food_Display_-_NCI_Visuals_Online.jpg",
                    "name": "Food Order",
                    "prefill": [
                        "contact": "9876543210",
                        "email": "foo@bar.com"
                    ],
                    "theme": [
                        "color": "#F37254"
                    ]
                ]
        razorpay.open(options)
    }
}
