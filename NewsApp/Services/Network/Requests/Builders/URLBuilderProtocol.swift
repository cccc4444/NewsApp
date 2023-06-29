//
//  URLBuilderProtocol.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

protocol URLBuilderProtocol {
    var path: String { get }
    var queries: Encodable? { get }

    func getURL() throws -> URL
}

extension URLBuilderProtocol {
    func getURL() throws -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.nytimes.com"
        urlComponents.path = path
        
        do {
            if let queries = try queries?.convertToDictionary() {
                urlComponents.setQueryItems(with: queries)
            }
        } catch {
            if let queries = try queries?.convertArrayToDictionary() {
                urlComponents.setMultipleQueryItems(with: queries)
            }
        }

        guard let finalURL = urlComponents.url else {
            throw NetworkError.URLConstruction.invalidFinalURL
        }

        return finalURL
    }
}
