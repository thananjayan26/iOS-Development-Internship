//
//  ViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 28/09/23.
//

import UIKit
import GoogleSignIn
import Kingfisher

protocol EmailDelegate{
    func emailCarry(email: String)
}

let defaults = UserDefaults.standard

// For user appearance customisation
struct Appearance {
    static let userInterfaceStyle = "userInterfaceStyle"
}

func setAppearanceStyle(style: Int) {
    defaults.setValue(style, forKey: Appearance.userInterfaceStyle)
}

func getAppearanceStyle() -> Int {
    defaults.integer(forKey: Appearance.userInterfaceStyle)
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var googleLoginButton: UIView!
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginBtn: UIButton!
    fileprivate var pwdVis: Bool!
    fileprivate var alertTxt: String!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var passwordTxtfield: UITextField!
    @IBOutlet weak var visibilityBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        // Setting large title to true
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Setting large title to false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func googleLogin(_ sender: Any) {
        // Google login logic
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard error == nil else { return }
            guard let signInResult = signInResult else { return }
            guard let homeTabBarController = self.storyboard?.instantiateViewController(withIdentifier: HomeTabBarController.identifier) else {
                print("Tab bar failed")
                return
            }
            guard let profile = signInResult.user.profile else { return }
            // If profile contains image
            if profile.hasImage {
                let userImageURL = profile.imageURL(withDimension: 320)
                KingfisherManager.shared.retrieveImage(with: userImageURL!, completionHandler: { result in
                    switch result {
                    case .success(let result):
                        // Creating user info
                        AppCoreData.instance.createUserInformation(userName: profile.name, userEmail: profile.email, userImage: result.image.jpegData(compressionQuality: 1.0))
                        
                    case .failure(_):
                        print("Google profile image retrieval failure")
                    }
                })
            } else {
                // Provide dummy profile image
                AppCoreData.instance.createUserInformation(userName: profile.name, userEmail: profile.email, userImage: nil)
            }
            // If successful login, switch to home page
            self.navigationController?.setViewControllers([homeTabBarController], animated: true)
          }
    }
    
    @objc func scrollViewTapped() {
        loginScrollView.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        // To dismiss keyboard
        let scrollTap2 = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollTap2.cancelsTouchesInView = false
        loginScrollView.addGestureRecognizer(scrollTap2)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switchBasedNextTextField(textField)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func switchBasedNextTextField(_ textField: UITextField) {
        // Switching control to textField
        if textField == emailTxtfield {
            self.passwordTxtfield.becomeFirstResponder()
        } else {
            self.passwordTxtfield.resignFirstResponder()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func visibilityBtnAction(_ sender: UIButton) {
        // Change password visibility
        pwdVis = passwordTxtfield.isSecureTextEntry
        if passwordTxtfield.isSecureTextEntry {
            visibilityBtn.setImage(UIImage.init(systemName: "eye.slash"), for: .normal)
        } else {
            visibilityBtn.setImage(UIImage.init(systemName: "eye"), for: .normal)
        }
        passwordTxtfield.isSecureTextEntry = !(passwordTxtfield.isSecureTextEntry)
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton) {
        guard let registerViewController = self.storyboard?.instantiateViewController(identifier: RegisterViewController.identifier) as? RegisterViewController else {
            print("Register view failed")
            return
        }
        registerViewController.emailDelegate = self
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        // Log in using textFields
        if emailTxtfield.text != "" && passwordTxtfield.text != "" {
            if isValidEmail(emailTxtfield.text!) {
                guard let homeTabBarController = self.storyboard?.instantiateViewController(withIdentifier: HomeTabBarController.identifier) else {
                    print("Tab bar failed")
                    return
                }
                // Create user details
                AppCoreData.instance.createUserInformation(userName: "Unknown User", userEmail: emailTxtfield.text!, userImage: nil)
                // Go to home page
                self.navigationController?.setViewControllers([homeTabBarController], animated: true)
                return
            } else {
                alertTxt = "Invalid email address"
            }
        } else {
            alertTxt = "Please enter credentials"
        }
        let alert = UIAlertController(title: "Alert", message: alertTxt, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true, completion: nil)
    }
}


extension ViewController: EmailDelegate {
    func emailCarry(email: String) {
        emailTxtfield.text = email
    }
}
