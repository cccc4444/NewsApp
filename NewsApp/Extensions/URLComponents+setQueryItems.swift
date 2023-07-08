//
//  URLComponents+setQueryItems.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.asUrlQueryItemsFromDict
    }
    
    mutating func setMultipleQueryItems(with parameters: [[String: String]]) {
        queryItems = parameters.asUrlQueryItems
    }
}

extension Dictionary where Key == String, Value == String {
    var asUrlQueryItemsFromDict: [URLQueryItem] {
        return map { .init(name: $0.key, value: $0.value) }
    }
}

extension Array where Element == [String: String] {
    var asUrlQueryItems: [URLQueryItem] {
        return map { $0.asUrlQueryItemsFromDict }.flatMap { $0 }
    }
}
