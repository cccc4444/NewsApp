//
//  MockPersistentError.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation

enum MockPersistentError: Error {
    case saveError
    case fetchError
    case isSavedError
    case deleteError
    case deleteAllError
}
