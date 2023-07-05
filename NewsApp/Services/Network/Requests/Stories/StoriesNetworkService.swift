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
    func fetchStories(for section: String) throws -> AnyPublisher<StoryModel, Error>
    func fetchMostViewedStories(days period: Int) throws -> AnyPublisher<MostViewedStoryModel, Error>
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
    
    func fetchStories(for section: String) throws -> AnyPublisher<StoryModel, Error> {
        let request = try RequestCreator(
            url: StoriesURLs.contentInSection(section: section),
            httpMethod: .get,
            header: .standard
        ).getRequest()
        
        return performDataTask(with: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func fetchMostViewedStories(days period: Int) throws -> AnyPublisher<MostViewedStoryModel, Error> {
        let request = try RequestCreator(
            url: StoriesURLs.mostViewed(periodInDays: period),
            httpMethod: .get,
            header: .standard
        ).getRequest()
        
        return performDataTask(with: request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
