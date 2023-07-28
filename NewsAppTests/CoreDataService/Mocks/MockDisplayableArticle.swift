//
//  MockDisplayableArticle.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
@testable import NewsApp

struct MockDisplayableArticle: DisplayableArticle {
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
    var multimedia: [NewsApp.Multimedia]?
    
    init(section: String, subsection: String, title: String, abstract: String, url: String, uri: String, byline: String, publishedDate: String, desFacet: [String], orgFacet: [String], perFacet: [String], geoFacet: [String], multimedia: [Multimedia]? = nil) {
        self.section = section
        self.subsection = subsection
        self.title = title
        self.abstract = abstract
        self.url = url
        self.uri = uri
        self.byline = byline
        self.publishedDate = publishedDate
        self.desFacet = desFacet
        self.orgFacet = orgFacet
        self.perFacet = perFacet
        self.geoFacet = geoFacet
        self.multimedia = multimedia
    }
    
    static func createStubArticle(title: String) -> Self {
        return .init(section: "", subsection: "", title: title, abstract: "", url: "", uri: "", byline: "", publishedDate: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [])
    }
}
