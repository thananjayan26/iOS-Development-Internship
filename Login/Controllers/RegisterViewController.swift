//
//  RegisterViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 29/09/23.
//

import UIKit
import PhotosUI


class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var emailDelegate: EmailDelegate!

    static var identifier: String {
        return String(describing: self)
    }

    @IBOutlet weak var pwdCheckLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var dobPicker: UIDatePicker!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var choosePicBtn: UIButton!
    @IBOutlet weak var checkBoxBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var registerScrollView: UIScrollView!
    fileprivate var alertTxt: String! = ""
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        profileImage.image = image
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func choosePicBtnClicked(_ sender: UIButton) {
        //  To choose profile pic
        let imageController = UIImagePickerController()
        imageController.delegate = self
        let actionSheet = UIAlertController(title: "Profile picture", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imageController.sourceType = .camera
                self.present(imageController, animated: true, completion: nil)
            } else {
                print("No camera")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: {
            (action:UIAlertAction) in
            imageController.sourceType = .photoLibrary
            self.present(imageController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func checkBoxBtnClicked(_ sender: UIButton) {
        // To switch checkBox state
        checkBoxBtn.isSelected = !checkBoxBtn.isSelected
    }
    
    @IBAction func genderBtnClicked(_ sender: UIButton) {
        // Radio Buttons logic
        if sender == maleBtn {
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
            otherBtn.isSelected = false
        } else if sender == femaleBtn {
            maleBtn.isSelected = false
            femaleBtn.isSelected = true
            otherBtn.isSelected = false
        } else {
            maleBtn.isSelected = false
            femaleBtn.isSelected = false
            otherBtn.isSelected = true
        }
    }
    
    func updateAlertTxt(updation: String){
        if alertTxt.isEmpty {
            alertTxt += updation
        } else {
            alertTxt += "\n" + updation
        }
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        // Checking if fields are filled and valid
        alertTxt = ""
        if profileImage.image != UIImage.init(systemName: "person.circle.fill") && firstNameTextField.text != "" && lastNameTextField.text != "" && pwdTextField.text != "" && confirmPwdTextField.text != "" && mobileTextField.text != "" && emailTextField.text != "" && checkBoxBtn.isSelected && (maleBtn.isSelected || femaleBtn.isSelected || otherBtn.isSelected) {
            if !isValidEmail(emailTextField.text!) {
                updateAlertTxt(updation: "Invalid email address")
            }
            if mobileTextField.text!.count != 10 {
                updateAlertTxt(updation: "Invalid mobile number")
            }
            if pwdCheckLabel.textColor == .red {
                updateAlertTxt(updation: "Passwords do not match")
            }
            
            if alertTxt.isEmpty {
                emailDelegate.emailCarry(email: emailTextField.text!)
                guard self.storyboard?.instantiateViewController(identifier: ViewController.identifier) is ViewController else {
                    print("Segue no")
                    return
                }
                navigationController?.popViewController(animated: true)
                return
            }
        } else {
            alertTxt = "Please complete form"
        }
        let alert = UIAlertController(title: "Alert", message: alertTxt, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func pwdOnChange(_ sender: UITextField) {
        // Checking if passwords match
        if pwdTextField.text != confirmPwdTextField.text {
            pwdCheckLabel.text = "Passwords do not match"
            pwdCheckLabel.isHidden = false
            pwdCheckLabel.textColor = .red
        } else if pwdTextField.text!.isEmpty && confirmPwdTextField.text!.isEmpty {
            pwdCheckLabel.isHidden = true
        } else {
            pwdCheckLabel.text = "Passwords match"
            pwdCheckLabel.isHidden = false
            pwdCheckLabel.textColor = UIColor(red: 0.200, green: 0.509, blue: 0.266, alpha: 1)
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @objc func scrollViewTapped() {
        registerScrollView.endEditing(true)
    }
    
    func configureViews() {
        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = true
        dobPicker.maximumDate = Date()
        maleBtn.setImage(UIImage.init(systemName: "circle"), for: .normal)
        maleBtn.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .selected)
        femaleBtn.setImage(UIImage.init(systemName: "circle"), for: .normal)
        femaleBtn.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .selected)
        otherBtn.setImage(UIImage.init(systemName: "circle"), for: .normal)
        otherBtn.setImage(UIImage.init(systemName: "circle.inset.filled"), for: .selected)
        checkBoxBtn.setImage(UIImage.init(systemName: "square"), for: .normal)
        checkBoxBtn.setImage(UIImage.init(systemName: "checkmark.square.fill"), for: .selected)
        
        self.firstNameTextField.delegate = self
        self.lastNameTextField.delegate = self
        self.pwdTextField.delegate = self
        self.confirmPwdTextField.delegate = self
        self.emailTextField.delegate = self
        self.mobileTextField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To dismiss keyboard
        let scrollTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        registerScrollView.addGestureRecognizer(scrollTap)

        // Configuring views
        configureViews()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Checking if number is valid
        if textField == mobileTextField {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        // Switching control to textFields
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            pwdTextField.becomeFirstResponder()
        case pwdTextField:
            confirmPwdTextField.becomeFirstResponder()
        case confirmPwdTextField:
            mobileTextField.becomeFirstResponder()
        case mobileTextField:
            emailTextField.becomeFirstResponder()
        default:
            emailTextField.resignFirstResponder()
        }
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


