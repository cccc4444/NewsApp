//
//  Collection+Safe.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    subscript (safe index: Index?) -> Element? {
        guard let index else { return nil }
        return self[safe: index]
    }
}
