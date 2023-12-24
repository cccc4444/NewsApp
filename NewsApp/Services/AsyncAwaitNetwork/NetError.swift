//
//  NetError.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 24.12.2023.
//

import Foundation

public enum NetError: Error {
    case httpError(statusCode: Int)
    case decodingError(Error)
}
