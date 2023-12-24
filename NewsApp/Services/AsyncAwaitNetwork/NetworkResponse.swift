//
//  NetworkResponse.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 24.12.2023.
//

import Foundation

public protocol NetworkResponse: Codable { }
extension Array: NetworkResponse where Element: NetworkResponse { }
