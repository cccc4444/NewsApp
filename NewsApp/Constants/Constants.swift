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
    
    struct CoreData {
        static let entityName = "LikedArticle"
    }
    
    struct LocalNotifications {
        static let categoryIdentifier = "dailyNotification"
        static let title = "Hey"
        static let body = "Check out the latest stories"
        static let deleteAction = "DeleteAction"
        static let deleteActionTitle = "Delete"
        static let hour: Int = 11
        static let minute: Int = 0
        static let badge: NSNumber = 1
    }
    
    struct Keychain {
        static let service = "serviceIdentifier"
        static let key = "articles"
    }
    
    struct HomeViewController {
        static let defaultSectionName = "Top"
        static let navBarTitlePadding: CGFloat = 5
        static let navBarImagePadding: CGFloat = 5
        static let trailingArchieveActionTitle = "Archive"
        static let trailingSecretActionTitle = "Secret"
        
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
    
    struct LikedViewController {
        static let secretSectionName = "Secret 🔒"
        static let removeAll = "Remove all"
        static let favouritesTitle = "Favourites"
        static let removeTitle = "Remove"
        struct Lottie {
            static let name = "animationBlack.json"
        }
    }
    
    struct ThemesViewController {
        static let themeItems = ["System", "Light", "Dark"]
    }
    
    struct NotificationBannerConstants {
        static let title = "Hey"
        static let subtitle = "Reconsider your life choices!"
    }
}
// swiftlint:enable nesting
