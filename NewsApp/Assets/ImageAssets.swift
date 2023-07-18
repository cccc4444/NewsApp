//
//  ImageAssets.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 04.07.2023.
//

import Foundation
import UIKit

enum SystemAssets: CaseIterable {
    case top
    case art
    case automobiles
    case books
    case business
    case educations
    case fashion
    case food
    case health
    case movies
    case science
    case sports
    case travel
    case world
    case share
    case like
    case liked
    case likePressed
    case gear
    case theme
    
    var image: UIImage? {
        return UIImage(systemName: assetName)
    }
    
    var assetName: String {
        switch self {
        case .top:
            "popcorn.fill"
        case .art:
            "photo.artframe"
        case .automobiles:
            "car.fill"
        case .books:
            "book.fill"
        case .business:
            "dollarsign"
        case .educations:
            "graduationcap.fill"
        case .fashion:
            "tshirt.fill"
        case .food:
            "fork.knife"
        case .health:
            "heart.text.square"
        case .movies:
            "film.fill"
        case .science:
            "atom"
        case .sports:
            "basketball.fill"
        case .travel:
            "water.waves"
        case .world:
            "globe.central.south.asia.fill"
        case .share:
            "square.and.arrow.up"
        case .like:
            "bookmark.square"
        case .likePressed:
            "bookmark.fill"
        case .liked:
            "bookmark"
        case .gear:
            "gear"
        case .theme:
            "circle.lefthalf.filled"
        }
    }
}

enum ImagesAssets {
    case chevron
    case noImage
    
    var image: UIImage? {
        return UIImage(named: assetName)
    }
    
    var assetName: String {
        switch self {
        case .chevron: "chevron"
        case .noImage: "noImage"
        }
    }
}

extension UIImage {
    convenience init?(named: ImagesAssets) {
        self.init(named: named.assetName)
    }
    
    convenience init?(systemNamed: SystemAssets) {
        self.init(systemName: systemNamed.assetName)
    }
}
