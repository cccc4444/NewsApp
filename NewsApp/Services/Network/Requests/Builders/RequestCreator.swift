//
//  RequestCreator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

class RequestCreator: RequestBuilderProtocol {
    var url: URLBuilderProtocol
    let httpMethod: HTTPMethod
    var body: Encodable?
    var boundary: String?
    var header: HeaderType
    
    init(url: URLBuilderProtocol, httpMethod: HTTPMethod, body: Encodable? = nil, header: HeaderType, boundary: String? = nil) {
        self.url = url
        self.httpMethod = httpMethod
        self.body = body
        self.boundary = boundary
        self.header = header
    }
}

