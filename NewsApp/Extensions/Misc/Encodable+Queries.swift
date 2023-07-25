//
//  Encodable+Queries.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

extension Encodable {
    func convertToDictionary() throws -> [String: String] {
        let data = try encodeData()
        guard let dictionary = try?
                JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: String] else {
                    throw NetworkError.EncodableExtensions.convertingToDictionaryFailed
        }
        return dictionary
    }
    
    func convertArrayToDictionary() throws -> [[String: String]] {
        let data = try encodeData()
        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: String]] else {
                    throw NetworkError.EncodableExtensions.convertingToDictionaryFailed
        }
        return dictionary
    }

    func encodeData() throws -> Data {
        do {
            return try JSONEncoder().encode(self)
        } catch {
            throw NetworkError.EncodableExtensions.dataEncodingFailed
        }
    }
}
