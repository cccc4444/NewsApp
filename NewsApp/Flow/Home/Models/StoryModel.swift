//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 05.07.2023.
//

import Foundation

struct StoryModel: Codable {
    let status: String
    let copyright: String
    let section: String
    let lastUpdated: String
    let numResults: Int
    let results: [ArticleModel]
    
    private enum CodingKeys: String, CodingKey {
        case status, copyright, section
        case lastUpdated = "last_updated"
        case numResults = "num_results"
        case results
    }
}

struct ArticleModel: Codable {
    let section: String
    let subsection: String
    let title: String
    let abstract: String
    let url: String
    let uri: String
    let byline: String
    let itemType: String
    let updatedDate: String
    let createdDate: String
    let publishedDate: String
    let materialTypeFacet: String
    let kicker: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let multimedia: [Multimedia]
    let shortUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, uri, byline
        case itemType = "item_type"
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker, desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case multimedia
        case shortUrl = "short_url"
    }
}

struct Multimedia: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    let type: String
    let subtype: String
    let caption: String
    let copyright: String
    
    private enum CodingKeys: String, CodingKey {
        case url, format, height, width, type, subtype, caption, copyright
    }
}
