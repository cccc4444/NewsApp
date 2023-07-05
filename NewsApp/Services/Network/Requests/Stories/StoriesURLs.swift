//
//  StoriesURLs.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

enum StoriesURLs: URLBuilderProtocol {
    case sectionList
    case contentInSection(section: String)
    case mostViewed(periodInDays: Int)
    
    var path: String {
        switch self {
        case .sectionList:
            "/svc/news/v3/content/section-list.json"
        case .contentInSection(let section):
            "/svc/topstories/v2/\(section).json"
        case .mostViewed(let periodInDays):
            "/svc/mostpopular/v2/viewed/\(periodInDays).json"
        }
    }
    
    var queries: Encodable? {
        switch self {
        case .sectionList, .contentInSection, .mostViewed:
            ApiKeyQuery(apikey: Constants.Secret.apiKey)
        }
    }
}
