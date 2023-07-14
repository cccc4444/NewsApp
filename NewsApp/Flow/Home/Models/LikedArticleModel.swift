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
    
    init?(title: String?, author: String?, url: String?) {
        guard let title, let author, let url else {
            return nil
        }
        self.title = title
        self.author = author
        self.url = url
    }
}
