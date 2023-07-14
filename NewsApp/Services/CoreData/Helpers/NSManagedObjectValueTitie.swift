//
//  NSManagedObjectValueTitie.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation

enum ManagedValueType {
    case title
    case author
    case url
    
    var value: String {
        switch self {
        case .title: "title"
        case .author: "author"
        case .url: "url"
        }
    }
}
