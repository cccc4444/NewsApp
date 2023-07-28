//
//  MockStoriesNetworkService.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import Combine
@testable import NewsApp


class MockStoriesNetworkService: StoriesNetworkServiceProtocol {
    var sectionListResult: Swift.Result<SectionListModel, Error>!
    var storiesResult: Swift.Result<StoryModel, Error>!
    var mostViewedStoriesResult: Swift.Result<MostViewedStoryModel, Error>!

    func fetchSectionList() throws -> AnyPublisher<SectionListModel, Error> {
        if let sectionListResult {
            return createPublisher(for: sectionListResult)
                .eraseToAnyPublisher()
        } else {
            return createPublisher(for: .failure(MockNetworkError.fetchSectionListError))
                .eraseToAnyPublisher()
        }
    }
    
    func fetchStories(for section: String) throws -> AnyPublisher<StoryModel, Error> {
        if let storiesResult {
            return createPublisher(for: storiesResult)
                .eraseToAnyPublisher()
        } else {
            return createPublisher(for: .failure(MockNetworkError.fetchStoriesError))
                .eraseToAnyPublisher()
        }
    }
    
    func fetchMostViewedStories(days period: Int) throws -> AnyPublisher<MostViewedStoryModel, Error> {
        if let mostViewedStoriesResult {
            return createPublisher(for: mostViewedStoriesResult)
        } else {
            return createPublisher(for: .failure(MockNetworkError.fetchMostViewedStoriesError))
                .eraseToAnyPublisher()
        }
    }
}

extension MockStoriesNetworkService {
    private func createPublisher<T, Error>(for result: Swift.Result<T, Error>) -> AnyPublisher<T, Error> {
        let subject = PassthroughSubject<T, Error>()
        switch result {
        case let .success(value):
            subject.send(value)
            subject.send(completion: .finished)
        case let .failure(error):
            subject.send(completion: .failure(error))
        }
        return subject.eraseToAnyPublisher()
    }
}
