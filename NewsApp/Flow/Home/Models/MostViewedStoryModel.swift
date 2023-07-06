//
//  MostViewedStoryModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 05.07.2023.
//

import Foundation

struct MostViewedStoryModel: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [MostViewedArticleModel]
    
    private enum CodingKeys: String, CodingKey {
        case status, copyright, numResults = "num_results", results
    }
}

struct MostViewedArticleModel: Codable {
    let uri: String
    let url: String
    let id: Int
    let assetId: Int
    let source: String
    let publishedDate: String
    let updated: String
    let section: String
    let subsection: String
    let nytdsection: String
    let adxKeywords: String
    let column: String?
    let byline: String
    let type: String
    let title: String
    let abstract: String
    let desFacet: [String]
    let orgFacet: [String]
    let perFacet: [String]
    let geoFacet: [String]
    let media: [Media]
    let etaId: Int
    
    private enum CodingKeys: String, CodingKey {
        case uri, url, id, assetId = "asset_id", source, publishedDate = "published_date", updated, section, subsection, nytdsection, adxKeywords = "adx_keywords", column, byline, type, title, abstract, desFacet = "des_facet", orgFacet = "org_facet", perFacet = "per_facet", geoFacet = "geo_facet", media, etaId = "eta_id"
    }
    
    var mediaURL: String? {
        media.first?.mediaMetadata[1].url
    }
}

struct Media: Codable {
    let type: String
    let subtype: String
    let caption: String
    let copyright: String
    let approvedForSyndication: Int?
    let mediaMetadata: [MediaMetadata]
    
    private enum CodingKeys: String, CodingKey {
        case type, subtype, caption, copyright, approvedForSyndication, mediaMetadata = "media-metadata"
    }
}

struct MediaMetadata: Codable {
    let url: String
    let format: String
    let height: Int
    let width: Int
    let itemType: String?
    
    private enum CodingKeys: String, CodingKey {
        case url, format, height, width, itemType = "item_type"
    }
}


extension MostViewedArticleModel {
    static let empty: Self = .init(uri: "", url: "", id: 1, assetId: 1, source: "", publishedDate: "", updated: "", section: "", subsection: "", nytdsection: "", adxKeywords: "", column: nil, byline: "", type: "", title: "", abstract: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], media: [], etaId: 0)
}
