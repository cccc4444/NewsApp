//
//  StoriesNetworkServiceTests.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import XCTest
@testable import NewsApp

class StoriesNetworkServiceTests: XCTestCase {
    var mockNetworkService: MockStoriesNetworkService!
    
    override func setUpWithError() throws {
        mockNetworkService = MockStoriesNetworkService()
    }
    
    override func tearDownWithError() throws {
        mockNetworkService = nil
    }
    
    func testFetchSectionList() {
        let expectedResult = SectionListModel.stub
        mockNetworkService.sectionListResult = .success(expectedResult)
        
        let cancellable = try? mockNetworkService.fetchSectionList().sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
            }
        )
        cancellable?.cancel()
    }
    
    func testFetchSectionListFailure() {
        let cancellable = try? mockNetworkService.fetchSectionList().sink(
            receiveCompletion: { _ in },
            receiveValue: { [unowned self] result in
                self.XCTAssertThrows(expression: result, error: MockNetworkError.fetchSectionListError)
            }
        )
        cancellable?.cancel()
    }
    
    func testFetchStories() {
        let expectedResult = StoryModel.stub
        mockNetworkService.storiesResult = .success(expectedResult)
        
        let cancellable = try? mockNetworkService.fetchStories(for: .dummy).sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
            }
        )
        cancellable?.cancel()
    }
    
    func testFetchStoryFailure() {
        let cancellable = try? mockNetworkService.fetchStories(for: .dummy).sink(
            receiveCompletion: { _ in },
            receiveValue: { [unowned self] result in
                self.XCTAssertThrows(expression: result, error: MockNetworkError.fetchStoriesError)
            }
        )
        cancellable?.cancel()
    }
    
    func testFetchMostViewedStories() {
        let expectedResult = MostViewedStoryModel.stub
        mockNetworkService.mostViewedStoriesResult = .success(expectedResult)
        
        let cancellable = try? mockNetworkService.fetchMostViewedStories(days: .dummy).sink(
            receiveCompletion: { _ in },
            receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
            }
        )
        cancellable?.cancel()
    }
    
    func testFetchMostViewedStoriesFailure() {
        let cancellable = try? mockNetworkService.fetchMostViewedStories(days: .dummy).sink(
            receiveCompletion: { _ in },
            receiveValue: { [unowned self] result in
                self.XCTAssertThrows(expression: result, error: MockNetworkError.fetchMostViewedStoriesError)
            }
        )
        cancellable?.cancel()
    }
}


fileprivate extension XCTestCase {
    func XCTAssertThrows<ErrorType: Error, T>(expression: @autoclosure () throws -> T, error: ErrorType) where ErrorType: Equatable {
        do {
            _ = try expression()
            XCTFail("No error thrown")
        } catch let caughtError as ErrorType {
            XCTAssertEqual(caughtError, error)
        } catch {
            XCTFail("Wrong error")
        }
    }
}
