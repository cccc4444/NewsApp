//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 27.07.2023.
//

import XCTest
@testable import NewsApp

final class ArticleKeychainServiceTests: XCTestCase {
    var mockKeychainService: MockKeychainService!
    
    override func setUpWithError() throws {
        mockKeychainService = MockKeychainService()
    }
    
    override func tearDownWithError() throws {
        mockKeychainService = nil
    }
    
    func testStoreArticle() {
        let article = SecretArticle.createStubArticle(title: "foo")
        XCTAssertTrue(mockKeychainService.articles.isEmpty)
        
        mockKeychainService.store(article: article) { _ in }
        
        XCTAssertEqual(mockKeychainService.articles.count, 1)
        XCTAssertEqual(mockKeychainService.articles.first?.title, "foo")
    }
    
    func testStoreArticleFailure() {
        let article = SecretArticle.createStubArticle(title: "foo")
        XCTAssertTrue(mockKeychainService.articles.isEmpty)
        mockKeychainService.shouldFail = true
        
        mockKeychainService.store(article: article) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .storeError)
            }
        }
        
        XCTAssertTrue(mockKeychainService.articles.isEmpty)
    }
    
    func testRetrieveArticle() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.retrieveArticles { result in
            if case .success(let articles) = result {
                XCTAssertEqual(articles.count, 2)
                XCTAssertEqual(articles[0].title, "foo")
                XCTAssertEqual(articles[1].title, "boo")
            }
        }
    }
    
    func testRetrieveArticleFailure() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.shouldFail = true
        
        mockKeychainService.retrieveArticles { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .retrieveError)
            }
        }
    }
    
    func testRemoveArticle() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.removeAt(index: 0) { _ in }
        
        XCTAssertEqual(mockKeychainService.articles.count, 1)
        XCTAssertEqual(mockKeychainService.articles.first?.title, "boo")
    }
    
    func testRemoveArticleFailure() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.shouldFail = true
        
        mockKeychainService.removeAt(index: 0) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .removeError)
            }
        }
    }
    
    func testRemoveArticeleWithInvalidIndex() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.removeAt(index: 2) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .removeError)
            }
        }
    }
    
    func testRemoveAllArticles() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.removeAll { _ in }
        
        XCTAssertTrue(mockKeychainService.articles.isEmpty)
    }
    
    func testRemoveAllArticlesFailure() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        mockKeychainService.store(article: article2) { _ in }
        
        mockKeychainService.removeAll { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .removeAllError)
            }
        }
    }
    
    func testIsArticleSaved() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        
        mockKeychainService.isSaved(article: article1) { result in
            if case .success(let isSaved) = result {
                XCTAssertFalse(isSaved)
            }
        }
        
        mockKeychainService.store(article: article1) { _ in }
        
        mockKeychainService.isSaved(article: article1) { result in
            if case .success(let isSaved) = result {
                XCTAssertTrue(isSaved)
            }
        }
    }
    
    func testIsArticleSavedWithWrongTitle() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        let article2 = SecretArticle.createStubArticle(title: "boo")
        
        mockKeychainService.store(article: article1) { _ in }
        
        mockKeychainService.isSaved(article: article2) { result in
            if case .success(let isSaved) = result {
                XCTAssertFalse(isSaved)
            }
        }
    }
    
    func testIsArticleSavedFailure() {
        let article1 = SecretArticle.createStubArticle(title: "foo")
        
        mockKeychainService.store(article: article1) { _ in }
        
        mockKeychainService.shouldFail = false
        
        mockKeychainService.isSaved(article: article1) { result in
            if case .failure(let error) = result {
                XCTAssertEqual(error as? MockError, .isSavedError)
            }
        }
    }
}
