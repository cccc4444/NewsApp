//
//  KeyChainService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 21.07.2023.
//

import Foundation
import Security
import SimpleKeychain

protocol KeychainServiceInterface {
    func store(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void)
    func retrieveArticles(completion: @escaping (Swift.Result<[SecretArticle], Error>) -> Void)
    func removeAt(index: Int, completion: @escaping (Swift.Result<Bool, Error>) -> Void)
    func removeAll(completion: @escaping (Swift.Result<Bool, Error>) -> Void)
    func isSaved(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void)
}

class ArticleKeychainService: KeychainServiceInterface {
    
    static let shared = ArticleKeychainService()
    
    func store(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        let keychain = SimpleKeychain(service: Constants.Keychain.service)
        do {
            var existingArticles = getExistingArticles()
            existingArticles.append(article)
            
            let data = try JSONEncoder().encode(existingArticles)
            try keychain.set(data, forKey: Constants.Keychain.key)
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    func retrieveArticles(completion: @escaping (Swift.Result<[SecretArticle], Error>) -> Void) {
        let keychain = SimpleKeychain(service: Constants.Keychain.service)
        do {
            guard isArticleStored else {
                completion(.success([]))
                return
            }
            
            let data = try keychain.data(forKey: Constants.Keychain.key)
            let articles = try JSONDecoder().decode([SecretArticle].self, from: data)
            completion(.success(articles))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeAt(index: Int, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        let keychain = SimpleKeychain(service: Constants.Keychain.service)
        do {
            var existingArticles = getExistingArticles()
            existingArticles.remove(at: index)
            
            let data = try JSONEncoder().encode(existingArticles)
            try keychain.set(data, forKey: Constants.Keychain.key)
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    func removeAll(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        let keychain = SimpleKeychain(service: Constants.Keychain.service)
        do {
            try keychain.deleteItem(forKey: Constants.Keychain.key)
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    func isSaved(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        completion(.success(getExistingArticles()
            .contains {
                $0.title == article.title
            })
        )
    }
}

extension ArticleKeychainService {
    private func getExistingArticles() -> [SecretArticle] {
        var existingArticles = [SecretArticle]()
        retrieveArticles { result in
            if case let .success(data) = result {
                existingArticles = data
            }
        }
        return existingArticles
    }
    
    private var isArticleStored: Bool {
        do {
            let keychain = SimpleKeychain(service: Constants.Keychain.service)
            return try keychain.hasItem(forKey: Constants.Keychain.key)
        } catch {
            return false
        }
    }
}


extension Array {
    func contains<T>(_ obj: T) -> Bool where T: Equatable {
        return !self.filter({$0 as? T == obj}).isEmpty
    }
}
