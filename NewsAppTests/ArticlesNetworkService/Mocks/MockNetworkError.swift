//
//  MockNetworkError.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation

enum MockNetworkError: Error {
    case fetchSectionListError
    case fetchStoriesError
    case fetchMostViewedStoriesError
}
