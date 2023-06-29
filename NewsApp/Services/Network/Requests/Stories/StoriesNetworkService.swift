//
//  StoriesNetworkService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import UIKit
import Combine

protocol StoriesNetworkServiceProtocol {
    func fetchSectionList() throws -> AnyPublisher<SectionListModel, Error>
}

class StoriesNetworkService: StoriesNetworkServiceProtocol, NetworkServiceProtocol {
    func fetchSectionList() throws -> AnyPublisher<SectionListModel, Error> {
        let request = try RequestCreator(
            url: StoriesURLs.sectionList,
            httpMethod: .get,
            header: .standard
        ).getRequest()
        
        return performDataTask(with: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
