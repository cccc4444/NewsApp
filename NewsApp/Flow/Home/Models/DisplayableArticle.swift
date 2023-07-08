//
//  DisplayableArticle.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 07.07.2023.
//

import Foundation

protocol DisplayableArticle {
    var section: String { get }
    var subsection: String { get }
    var title: String { get }
    var abstract: String { get }
    var url: String { get }
    var uri: String { get }
    var byline: String { get }
    var publishedDate: String { get }
    var desFacet: [String] { get }
    var orgFacet: [String] { get }
    var perFacet: [String] { get }
    var geoFacet: [String] { get }
    var multimedia: [Multimedia] { get }
}

extension DisplayableArticle {
    var mediaURL: String? {
        return multimedia[safe: 1]?.url
    }
}

extension ArticleModel: DisplayableArticle {}
extension MostViewedArticleModel: DisplayableArticle {
    var multimedia: [Multimedia] {
        media.flatMap { media in
            media.mediaMetadata.map {
                .init(url: $0.url,
                      format: $0.format,
                      height: $0.height,
                      width: $0.width,
                      type: media.type,
                      subtype: media.subtype,
                      caption: media.caption,
                      copyright: media.copyright)
            }
        }
    }
}
