//
//  ModelStubs.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
@testable import NewsApp

extension SectionListModel: Equatable {
    static var stub: Self = .init(status: "stub", copyright: "stub", numResults: 999, results: [])
    
    public static func == (lhs: SectionListModel, rhs: SectionListModel) -> Bool {
        return lhs.results == rhs.results
    }
}

extension StoryModel: Equatable {
    static var stub: Self = .init(status: "status", copyright: "cop", section: "sec", lastUpdated: "12", numResults: 999, results: [])
    
    public static func == (lhs: StoryModel, rhs: StoryModel) -> Bool {
        return lhs.results == rhs.results
    }
}

extension ArticleModel: Equatable {
    public static func == (lhs: ArticleModel, rhs: ArticleModel) -> Bool {
        return lhs.title == rhs.title
    }
}

extension MostViewedArticleModel: Equatable {
    public static func == (lhs: MostViewedArticleModel, rhs: MostViewedArticleModel) -> Bool {
        return lhs.title == rhs.title
    }
}

extension MostViewedStoryModel: Equatable {
    static var stub: Self = .stub
    public static func == (lhs: MostViewedStoryModel, rhs: MostViewedStoryModel) -> Bool {
        return lhs.results == rhs.results
    }
}
