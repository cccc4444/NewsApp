//
//  StoriesURLs.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

enum StoriesURLs: URLBuilderProtocol {
    case sectionList
    
    var path: String {
        switch self {
        case .sectionList:
            "/svc/news/v3/content/section-list.json"
        }
    }
    
    var queries: Encodable? {
        switch self {
        case .sectionList:
            ApiKeyQuery(apikey: Constants.Secret.apiKey)
        }
    }
}
