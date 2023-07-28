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
            completion(.failure(MockKeychainError.storeError))
        } else {
            articles.append(article)
            completion(.success(true))
        }
    }
    
    func retrieveArticles(completion: @escaping (Swift.Result<[SecretArticle], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockKeychainError.retrieveError))
        } else {
            completion(.success(articles))
        }
    }
    
    func removeAt(index: Int, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail || index < 0 || index >= articles.count {
            completion(.failure(MockKeychainError.removeError))
        } else {
            articles.remove(at: index)
            completion(.success(true))
        }
    }
    
    func removeAll(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockKeychainError.removeAllError))
        } else {
            articles.removeAll()
            completion(.success(true))
        }
    }
    
    func isSaved(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockKeychainError.isSavedError))
        } else {
            completion(.success(articles.contains { $0.title == article.title }))
        }
    }
}

