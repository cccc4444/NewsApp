//
//  UIView+Appearance.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation
import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func fadeIn(
        duration: TimeInterval = 0.2,
        delay: TimeInterval = 0.0,
        completion: @escaping (UIViewAnimatingPosition) -> Void = { _ in }
    ) {
        self.alpha = 0.0
        self.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        animator.addAnimations {
            self.alpha = 1.0
        }
        animator.addCompletion(completion)
        animator.startAnimation(afterDelay: delay)
    }
}

