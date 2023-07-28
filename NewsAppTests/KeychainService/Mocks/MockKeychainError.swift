//
//  MockError.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation

enum MockKeychainError: Error {
    case storeError
    case retrieveError
    case removeError
    case removeAllError
    case isSavedError
}
