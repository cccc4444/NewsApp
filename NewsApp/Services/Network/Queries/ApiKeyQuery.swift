//
//  ApiKeyQuery.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

struct ApiKeyQuery: Encodable {
    var apikey: String
    
    enum CodingKeys: String, CodingKey {
        case apikey = "api-key"
    }
}
