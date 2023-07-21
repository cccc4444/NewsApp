//
//  SecretArticle.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 21.07.2023.
//

import Foundation

struct SecretArticle: DisplayableArticle, Codable {
    var section: String
    var subsection: String
    var title: String
    var abstract: String
    var url: String
    var uri: String
    var byline: String
    var publishedDate: String
    var desFacet: [String]
    var orgFacet: [String]
    var perFacet: [String]
    var geoFacet: [String]
    var multimedia: [Multimedia]?
    
    init(displayableArticle: DisplayableArticle) {
        self.section = displayableArticle.section
        self.subsection = displayableArticle.subsection
        self.title = displayableArticle.title
        self.abstract = displayableArticle.abstract
        self.url = displayableArticle.url
        self.uri = displayableArticle.uri
        self.byline = displayableArticle.byline
        self.publishedDate = displayableArticle.publishedDate
        self.desFacet = displayableArticle.desFacet
        self.orgFacet = displayableArticle.orgFacet
        self.perFacet = displayableArticle.perFacet
        self.geoFacet = displayableArticle.geoFacet
        self.multimedia = displayableArticle.multimedia
    }
}
