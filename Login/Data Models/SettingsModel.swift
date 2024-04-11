//
//  SettingsModel.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 16/10/23.
//

import Foundation
import UIKit

struct SettingsOptions {
    let title: String
    let iconImageView: UIImage?
    let iconBackground: UIColor
    let handler: (() -> Void)
}

struct SettingsSwitchOptions {
    let title: String
    let iconImageView: UIImage?
    let iconBackground: UIColor
    let handler: (() -> Void)
    let isOn: Bool
}

struct UserDetails {
    let profilePicture: URL?
    let name: String?
    let email: String?
}

struct Section {
    let title: String
    let settings: [SettingsType]
}

enum SettingsType {
    case profileCell
    case directingCell(model: SettingsOptions)
    case toggleCell(model: SettingsSwitchOptions)
    case logOutCell(model: SettingsOptions)
    case segmentCell
}
