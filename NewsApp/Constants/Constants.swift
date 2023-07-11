//
//  Constants.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import OrderedCollections
// swiftlint:disable nesting

struct Constants {
    struct Secret {
        static let apiKey = "OUyhf3E7V9z5MMeDbrPht55FtNxBAsHU"
    }
    
    struct HomeViewController {
        static let defaultSectionName = "Top"
        static let navBarTitlePadding: CGFloat = 5
        static let navBarImagePadding: CGFloat = 5
        
        struct Sections {
            static let sectionsList = ["Top", "Arts", "Automobiles", "Books", "Business", "Education", "Fashion", "Food", "Health", "Movies", "Science", "Sports", "Travel", "World"]
            static let sectionsIcons: [String] = SystemAssets.allCases.map { $0.assetName }
            static let sectionListIcons = Dictionary(uniqueKeysWithValues: zip(sectionsList, sectionsIcons))
        }
    }
    
    struct DetailViewController {
        static let articleInfoReuseIdentifier = "NewsApp.InfoCollectionViewCell"
        static let articleDetailsReuseIdentifier = "NewsApp.DetailCollectionViewCell"
    }
}
// swiftlint:enable nesting
