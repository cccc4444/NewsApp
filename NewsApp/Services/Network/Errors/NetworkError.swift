//
//  NetworkError.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

struct NetworkError {
    enum URLConstruction: Error {
        case invalidQueries
        case invalidFinalURL
    }

    enum RequestConstruction: Error {
        case addingBodyFailed
    }

    enum EncodableExtensions: Error {
        case convertingToDictionaryFailed
        case dataEncodingFailed
    }

    enum DataTask: Error {
        case badServerResponse
    }
}
