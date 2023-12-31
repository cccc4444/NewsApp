//
//  SectionListModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

struct SectionListModel: Codable, NetworkResponse {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [SectionModel]
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numResults = "num_results"
        case results
    }
}

struct SectionModel: Codable, Equatable {
    let section: String
    let displayName: String
    
    enum CodingKeys: String, CodingKey {
        case section
        case displayName = "display_name"
    }
}
