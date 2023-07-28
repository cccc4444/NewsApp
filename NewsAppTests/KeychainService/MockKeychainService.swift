//
//  MockKeychainService.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
@testable import NewsApp

class MockKeychainService: KeychainServiceProtocol{
    var articles: [SecretArticle] = []
    var shouldFail = false
    
    func store(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.storeError))
        } else {
            articles.append(article)
            completion(.success(true))
        }
    }
    
    func retrieveArticles(completion: @escaping (Swift.Result<[SecretArticle], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.retrieveError))
        } else {
            completion(.success(articles))
        }
    }
    
    func removeAt(index: Int, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail || index < 0 || index >= articles.count {
            completion(.failure(MockError.removeError))
        } else {
            articles.remove(at: index)
            completion(.success(true))
        }
    }
    
    func removeAll(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.removeAllError))
        } else {
            articles.removeAll()
            completion(.success(true))
        }
    }
    
    func isSaved(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockError.isSavedError))
        } else {
            completion(.success(articles.contains { $0.title == article.title }))
        }
    }
}

enum MockError: Error {
    case storeError
    case retrieveError
    case removeError
    case removeAllError
    case isSavedError
}

extension SecretArticle {
    static func createStubArticle(title: String) -> Self {
        return .init(displayableArticle: ArticleModel(section: "test", subsection: "test", title: title, abstract: "abstract", url: "", uri: "", byline: "", itemType: "", updatedDate: "", createdDate: "", publishedDate: "", materialTypeFacet: "", kicker: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [], multimedia: [], shortUrl: ""))
    }
}

