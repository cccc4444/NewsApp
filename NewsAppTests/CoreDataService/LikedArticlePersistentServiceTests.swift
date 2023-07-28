//
//  LikedArticlePersistentServiceTests.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import XCTest
@testable import NewsApp

final class LikedArticlePersistentServiceTests: XCTestCase {
    var mockPersistentService: MockLikedArticlePersistentService!

    override func setUpWithError() throws {
        mockPersistentService = MockLikedArticlePersistentService()
    }

    override func tearDownWithError() throws {
        mockPersistentService = nil
    }

    func testSaveArticle() {
        let article = MockDisplayableArticle.createStubArticle(title: "foo")
        XCTAssertTrue(mockPersistentService.articles.isEmpty)
        
        mockPersistentService.saveArticle(with: article) { _ in }
        
        XCTAssertEqual(mockPersistentService.articles.count, 1)
        XCTAssertEqual(mockPersistentService.articles.first?.value(forKey: .title), "foo")
    }
    
    func testSaveArticleFailure() {
        let article = MockDisplayableArticle.createStubArticle(title: "foo")
        XCTAssertTrue(mockPersistentService.articles.isEmpty)
        
        mockPersistentService.shouldFail = true
        
        mockPersistentService.saveArticle(with: article) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockPersistentError, .saveError)
            }
        }
    }
    
    func testFetchArticles() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        let article2 = MockDisplayableArticle.createStubArticle(title: "boo")
        
        mockPersistentService.saveArticle(with: article1) { _ in }
        mockPersistentService.saveArticle(with: article2) { _ in }
        
        mockPersistentService.fetchArticles { _ in }
        
        XCTAssertEqual(mockPersistentService.articles.count, 2)
        XCTAssertEqual(mockPersistentService.articles[0].value(forKey: .title), "foo")
        XCTAssertEqual(mockPersistentService.articles[1].value(forKey: .title), "boo")
    }
    
    func testFetchArticlesFailure() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        
        mockPersistentService.saveArticle(with: article1) { _ in }
        
        mockPersistentService.shouldFail = true
        
        mockPersistentService.fetchArticles { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockPersistentError, .fetchError)
            }
        }
    }
    
    func testIsArticleSaved() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        let article2 = MockDisplayableArticle.createStubArticle(title: "boo")
        XCTAssertTrue(mockPersistentService.articles.isEmpty)
        
        mockPersistentService.saveArticle(with: article1) { result in }
        
        mockPersistentService.isArticleSaved(with: article1) { result in
            if case .success(let isSaved) = result {
                XCTAssertTrue(isSaved)
            }
        }
        
        mockPersistentService.isArticleSaved(with: article2) { result in
            if case .success(let isSaved) = result {
                XCTAssertFalse(isSaved)
            }
        }
    }
    
    func testIsArticleSavedFailure() {
        let article = MockDisplayableArticle.createStubArticle(title: "foo")
        mockPersistentService.saveArticle(with: article) { result in }
        
        mockPersistentService.shouldFail = true
        
        mockPersistentService.isArticleSaved(with: article) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockPersistentError, .isSavedError)
            }
        }
    }
    
    func testDeleteArticle() {
        let article = MockDisplayableArticle.createStubArticle(title: "foo")
        mockPersistentService.saveArticle(with: article) { result in }
        
        XCTAssertEqual(mockPersistentService.articles.count, 1)
        
        mockPersistentService.deleteArticle(with: article) { _ in }
        
        XCTAssertTrue(mockPersistentService.articles.isEmpty)
    }
    
    func testDeleteWrongArticle() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        let article2 = MockDisplayableArticle.createStubArticle(title: "boo")
        mockPersistentService.saveArticle(with: article1) { result in }
        
        mockPersistentService.deleteArticle(with: article2) { result in
            if case .success(let isDeleted) = result {
                XCTAssertFalse(isDeleted)
            }
        }
    }
    
    func testDeleteArticleFailure() {
        let article = MockDisplayableArticle.createStubArticle(title: "foo")
        mockPersistentService.saveArticle(with: article) { result in }
        
        mockPersistentService.shouldFail = true
        
        mockPersistentService.deleteArticle(with: article) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockPersistentError, .deleteError)
            }
        }
    }
    
    func testDeleteAllArticles() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        let article2 = MockDisplayableArticle.createStubArticle(title: "boo")
        
        mockPersistentService.saveArticle(with: article1) { _ in }
        mockPersistentService.saveArticle(with: article2) { _ in }
        
        mockPersistentService.deleteAllArticles { _ in }
        
        XCTAssertTrue(mockPersistentService.articles.isEmpty)
    }
    
    func testDeleteAllArticlesFailure() {
        let article1 = MockDisplayableArticle.createStubArticle(title: "foo")
        let article2 = MockDisplayableArticle.createStubArticle(title: "boo")
        
        mockPersistentService.saveArticle(with: article1) { _ in }
        mockPersistentService.saveArticle(with: article2) { _ in }
        
        mockPersistentService.shouldFail = true
        
        mockPersistentService.deleteAllArticles() { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockPersistentError, .deleteAllError)
            }
        }
    }
}
