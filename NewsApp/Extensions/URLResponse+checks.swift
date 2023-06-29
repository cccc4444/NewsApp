//
//  URLResponse+checks.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

extension URLResponse {
    var isSuccess: Bool {
        return asHTTPURLRespose.statusCode.isInBetween(of: 200, and: 299)
    }
    
    var asHTTPURLRespose: HTTPURLResponse {
        return self as? HTTPURLResponse ?? HTTPURLResponse()
    }
}

