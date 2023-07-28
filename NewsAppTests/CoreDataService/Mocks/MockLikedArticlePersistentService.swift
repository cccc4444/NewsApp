//
//  MockLikedArticlePersistentService.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import CoreData
import UIKit
@testable import NewsApp

class MockLikedArticlePersistentService: LikedArticlePersistentProtocol {
    var articles: [NSManagedObject] = []
    var shouldFail: Bool = false

    func saveArticle(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.saveError))
            return
        }
        let mockManagedObject = MockManagedObject(article: likedArticle)
        articles.append(mockManagedObject)
        
        completion(.success(true))
    }

    func fetchArticles(completion: @escaping (Swift.Result<[NSManagedObject], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.fetchError))
            return
        }
        completion(.success(articles))
    }

    func isArticleSaved(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.isSavedError))
            return
        }
        let isSaved = articles.contains {
            $0.value(forKey: .title) == likedArticle.title
        }
        completion(.success(isSaved))
    }

    func deleteArticle(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.deleteError))
            return
        }
        guard let index = articles.firstIndex(where: { $0.value(forKey: .title) == likedArticle.title }) else {
            completion(.success(false))
            return
        }

        articles.remove(at: index)
        completion(.success(true))
    }

    func deleteAllArticles(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.deleteAllError))
            return
        }
        articles.removeAll()
        completion(.success(true))
    }
}

