//
//  LikedArticleModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation

struct LikedArticleModel {
    let title: String
    let author: String
    let url: String
    let section: String
    
    init?(title: String?, author: String?, url: String?, section: String?) {
        guard let title, let author, let url, let section else {
            return nil
        }
        self.title = title
        self.author = author
        self.url = url
        self.section = section
    }
}

extension LikedArticleModel {
    static let empty: Self = .init(title: "", author: "", url: "", section: "")!
}
