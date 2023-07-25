//
//  UIImageVIew+setImage.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.alpha = 0
            self.image = image
            self.fadeIn()
        }
    }
}
