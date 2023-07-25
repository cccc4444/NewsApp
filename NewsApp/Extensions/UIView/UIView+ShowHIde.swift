//
//  UIView+ShowHIde.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 17.07.2023.
//

import Foundation
import UIKit

extension UIView {
    func hide(_ v: UIView) {
        guard v.isHidden else {
            v.isHidden = true
            v.alpha = 0.0
            return
        }
    }

    func show(_ v: UIView) {
        guard v.isNotHidden else {
            v.isHidden = false
            v.alpha = 1.0
            return
        }
    }
}

extension UIView {
    var isNotHidden: Bool {
        return !isHidden
    }
}

