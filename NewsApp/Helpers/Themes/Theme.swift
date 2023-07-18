//
//  Theme.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 18.07.2023.
//

import Foundation
import UIKit

enum Theme: Int, CaseIterable {
    case device
    case light
    case dark
}

extension Theme {
    var userInterfaceStyle: UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
