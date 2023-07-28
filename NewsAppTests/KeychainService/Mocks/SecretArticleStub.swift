//
//  SecretArticleStub.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
@testable import NewsApp

extension SecretArticle {
    static func createStubArticle(title: String) -> Self {
        return .init(displayableArticle: ArticleModel(section: "test", subsection: "test", title: title, abstract: "abstract", url: "", uri: "", byline: "", itemType: "", updatedDate: "", createdDate: "", publishedDate: "", materialTypeFacet: "", kicker: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], multimedia: [], shortUrl: ""))
    }
}
