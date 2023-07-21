//
//  ColorAssets.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 18.07.2023.
//

import Foundation
import UIKit

extension UIColor {
    enum ColorIdentifier: String {
        case blackWhite
    }

    convenience init!(_ colorIdentifier: ColorIdentifier) {
        self.init(named: colorIdentifier.rawValue)
    }
}
