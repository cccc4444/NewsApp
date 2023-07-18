//
//  UserDefaults+theme.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 18.07.2023.
//

import Foundation

extension UserDefaults {
    var theme: Theme {
        get {
            register(defaults: [#function: Theme.device.rawValue])
            return Theme(rawValue: integer(forKey: #function)) ?? .device
        }
        set {
            set(newValue.rawValue, forKey: #function)
        }
    }
}
