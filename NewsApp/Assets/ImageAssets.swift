//
//  ImageAssets.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 04.07.2023.
//

import Foundation
import UIKit

enum ImagesAssets {
    case chevron
    
    var image: UIImage? {
        return UIImage(named: assetName)
    }
    
    var assetName: String {
        switch self {
        case .chevron: "chevron"
        }
    }
}

extension UIImage {
    convenience init?(named: ImagesAssets) {
        self.init(named: named.assetName)
    }
}
