//
//  ProfileViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 12/10/23.
//

import UIKit
import GoogleSignIn
import CoreData

// Data to present in profile view controller
let modelData: [Section] = [
    Section(title: "Profile", settings: [SettingsType.profileCell]),
    Section(title: "General", settings: [
        SettingsType.directingCell(model: SettingsOptions(title: "Addresses", iconImageView: UIImage(systemName: "house"), iconBackground: .appTertiaryColour, handler: {print("Addresses")})),
        SettingsType.directingCell(model: SettingsOptions(title: "Payments", iconImageView: UIImage(systemName: "creditcard"), iconBackground: .cartGreen, handler: {print("Payments")})),
        SettingsType.directingCell(model: SettingsOptions(title: "Refunds", iconImageView: UIImage(systemName: "indianrupeesign"), iconBackground: .cartGreen, handler: {print("Refunds")})),
        SettingsType.directingCell(model: SettingsOptions(title: "Favourites", iconImageView: UIImage(systemName: "heart"), iconBackground: .systemPink, handler: {print("Favourites")}))
                                    ]),
    Section(title: "System", settings: [
        SettingsType.toggleCell(model: SettingsSwitchOptions(title: "Data Saver Mode", iconImageView: UIImage(systemName: "wifi"), iconBackground: .systemBlue, handler: {print("Data saver")}, isOn: false)),
        SettingsType.toggleCell(model: SettingsSwitchOptions(title: "Allow Notifications", iconImageView: UIImage(systemName: "bell"), iconBackground: .systemOrange, handler: {print("Notifs")}, isOn: true)),
        SettingsType.toggleCell(model: SettingsSwitchOptions(title: "Sound effects", iconImageView: UIImage(systemName: "speaker.wave.2"), iconBackground: .systemOrange, handler: {print("Sound fx")}, isOn: true))
                                    ]),
    Section(title: "Appearance", settings: [
        SettingsType.segmentCell
                                    ]),
    Section(title: "Account", settings: [
        SettingsType.logOutCell(model: SettingsOptions(title: "Log Out", iconImageView: UIImage(systemName: "rectangle.portrait.and.arrow.forward"), iconBackground: .red, handler: {print("Addresses")}))
                                    ])
    ]




class ProfileViewController: UIViewController {

    @IBOutlet weak var settingsTableView: UITableView!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var logOutButton: UIButton!
    var segmentCellIndex = 0
    
    @IBAction func onLogOutButtonClicked(_ sender: Any) {
        // Signing out the user
        GIDSignIn.sharedInstance.signOut()
        guard let logInViewController = self.storyboard?.instantiateViewController(identifier: ViewController.identifier) as? ViewController else {
            print("log in view controller not working")
            return
        }
        // Deleting user info and pushing to login page
        AppCoreData.instance.deleteUserInfo()
        self.navigationController?.setViewControllers([logInViewController], animated: true)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Configuring segmented control state
        if self.traitCollection.userInterfaceStyle == .light {
            segmentCellIndex = 0
        } else {
            segmentCellIndex = 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        self.navigationItem.largeTitleDisplayMode = .always
       
        settingsTableView.register(AppearanceSegmentTableViewCell.nib, forCellReuseIdentifier: AppearanceSegmentTableViewCell.identifier)
        settingsTableView.register(ToggleSettingTableViewCell.nib, forCellReuseIdentifier: ToggleSettingTableViewCell.identifier)
        settingsTableView.register(DirectingSettingTableViewCell.nib, forCellReuseIdentifier: DirectingSettingTableViewCell.identifier)
        settingsTableView.register(SettingsProfileTableViewCell.nib, forCellReuseIdentifier: SettingsProfileTableViewCell.identifier)
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

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Logic when cell selected
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == modelData.count - 1 {
            onLogOutButtonClicked((Any).self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Returning height of row based on sections
        if indexPath.section == 0 {
            return 100
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Setting title for header
        return modelData[section].title
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Setting height of header
        30
    }
}




extension ProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData[section].settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = modelData[indexPath.section].settings[indexPath.row]
        
        switch model.self {
        case .directingCell(let data):
            if let cell = settingsTableView.dequeueReusableCell(withIdentifier: DirectingSettingTableViewCell.identifier, for: indexPath) as? DirectingSettingTableViewCell {
                cell.setUpDirectingCell(data: data)
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        case .profileCell:
            if let cell = settingsTableView.dequeueReusableCell(withIdentifier: SettingsProfileTableViewCell.identifier, for: indexPath) as? SettingsProfileTableViewCell {
                cell.setUpProfileCell()
                return cell
            }
        case .logOutCell(let data):
            if let cell = settingsTableView.dequeueReusableCell(withIdentifier: DirectingSettingTableViewCell.identifier, for: indexPath) as? DirectingSettingTableViewCell {
                cell.setUpDirectingCell(data: data)
                return cell
            }
        case .toggleCell(let data):
            if let cell = settingsTableView.dequeueReusableCell(withIdentifier: ToggleSettingTableViewCell.identifier, for: indexPath) as? ToggleSettingTableViewCell {
                cell.setUpToggleCell(data: data)
                return cell
            }
        case .segmentCell:
            if let cell = settingsTableView.dequeueReusableCell(withIdentifier: AppearanceSegmentTableViewCell.identifier, for: indexPath) as? AppearanceSegmentTableViewCell {
                cell.appearanceSegmentCell.selectedSegmentIndex = segmentCellIndex
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension UITableViewCell {
    func setUpBasicCell(data: SettingsOptions) {
        self.imageView?.image = data.iconImageView
        self.textLabel?.text = data.title
    }
}
