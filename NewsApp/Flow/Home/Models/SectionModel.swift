//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 05.07.2023.
//

import Foundation

struct SectionModel: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case articles = "results"
    }
}

struct Article: Codable {
    let slugName: String
    let section: String
    let subsection: String
    let title: String
    let abstract: String
    let uri: String
    let url: String
    let byline: String
    let itemType: String
    let source: String
    let updatedDate: String
    let createdDate: String
    let publishedDate: String
    let firstPublishedDate: String
    let materialTypeFacet: String
    let kicker: String
    let subheadline: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let relatedUrls: [[String: String]]
    let multimedia: [Multimedia]
    
    enum CodingKeys: String, CodingKey {
        case slugName = "slug_name"
        case section
        case subsection
        case title
        case abstract
        case uri
        case url
        case byline
        case itemType = "item_type"
        case source
        case updatedDate = "updated_date"
        case createdDate = "created_date"
        case publishedDate = "published_date"
        case firstPublishedDate = "first_published_date"
        case materialTypeFacet = "material_type_facet"
        case kicker
        case subheadline
        case desFacet = "des_facet"
        case orgFacet = "org_facet"
        case perFacet = "per_facet"
        case geoFacet = "geo_facet"
        case relatedUrls = "related_urls"
        case multimedia
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
}
