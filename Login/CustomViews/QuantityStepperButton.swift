//
//  QuantityStepperButton.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 09/11/23.
//

import UIKit

@IBDesignable
class QuantityStepperButton: UIView {

    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    var dishQuantity = 0
    var quantityButtonDelegate: QuantityButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
        
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "QuantityStepperButton") else { return }
        view.frame = self.bounds
        self.addSubview(view)
        hideQuantityButtons()
        addButton.layer.cornerRadius = 6
        addButton.layer.borderWidth = 0.75
        addButton.layer.borderColor = UIColor.appTertiaryColour.cgColor
    }
    
    @IBAction func addButtonTapped(sender: UIButton) {
        if dishQuantity > 0 {
            return
        }
        minusButton.isHidden = false
        plusButton.isHidden = false
        dishQuantity = 1
        updateAddButtonLabel(data: "\(dishQuantity)")
    }
    
    func updateAddButtonLabel(data: String) {
        print(data)
        addButton.setTitle(data, for: .normal)
        quantityButtonDelegate?.sendUpdatedQuantity(quantity: dishQuantity)
        
    }
    
    @IBAction func minusButtonTapped(sender: UIButton) {
        dishQuantity -= 1
        if dishQuantity == 0 {
            updateAddButtonLabel(data: "ADD")
            hideQuantityButtons()
        } else {
            updateAddButtonLabel(data: "\(dishQuantity)")
        }
    }
    
    @IBAction func plusButtonTapped(sender: UIButton) {
        print(dishQuantity)
        dishQuantity += 1
        updateAddButtonLabel(data: "\(dishQuantity)")
    }
    
    func hideQuantityButtons() {
        if dishQuantity == 0 {
            minusButton.isHidden = true
            plusButton.isHidden = true
            addButton.setTitle("ADD", for: .normal)
        } else {
            minusButton.isHidden = false
            plusButton.isHidden = false
            addButton.setTitle("\(dishQuantity)", for: .normal)
        }
    }
}


extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
