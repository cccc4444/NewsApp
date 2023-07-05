//
//  Constants.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import OrderedCollections

struct Constants {
    struct Secret {
        static let apiKey = "OUyhf3E7V9z5MMeDbrPht55FtNxBAsHU"
    }
    
    struct HomeViewController {
        static let navBarButtonDefaultName = "Default button"
        static let navBarTitlePadding: CGFloat = 5
        static let navBarImagePadding: CGFloat = 5
        
        struct Sections {
            static let sectionsList = ["Arts", "Books", "Business", "Education", "Fashion", "Food", "Health", "Movies", "Science", "Sports", "Travel", "World"]
            static let sectionsIcons: [String] = SystemAssets.allCases.map { $0.assetName }
            static let sectionListIcons = Dictionary(uniqueKeysWithValues: zip(sectionsList, sectionsIcons))
        }
    }
}
