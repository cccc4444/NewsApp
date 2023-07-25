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
}

class ArticleKeychainService: KeychainServiceInterface {
    
    static let shared = ArticleKeychainService()
    
    func store(article: SecretArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        do {
            var existingArticles = [SecretArticle]()
            retrieveArticles { result in
                if case let .success(data) = result {
                    existingArticles = data
                }
            }
            existingArticles.append(article)
            let data = try JSONEncoder().encode(existingArticles)
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            try keychain.set(data, forKey: "articles")
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    func retrieveArticles(completion: @escaping (Swift.Result<[SecretArticle], Error>) -> Void) {
        do {
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            guard try isArticleStored() else {
                completion(.success([]))
                return
            }
            
            let data = try keychain.data(forKey: "articles")
            let articles = try JSONDecoder().decode([SecretArticle].self, from: data)
            completion(.success(articles))
        } catch {
            completion(.failure(error))
        }
    }
    
    func removeAt(index: Int, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        do {
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            var existingArticles = [SecretArticle]()
            retrieveArticles { result in
                if case let .success(data) = result {
                    existingArticles = data
                }
            }
            
            existingArticles.remove(at: index)
            
            let data = try JSONEncoder().encode(existingArticles)
            try keychain.set(data, forKey: "articles")
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    func removeAll(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        do {
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            try keychain.deleteItem(forKey: "articles")
        } catch {
            completion(.failure(error))
        }
        completion(.success(true))
    }
    
    private func isArticleStored() throws -> Bool {
        do {
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            return try keychain.hasItem(forKey: "articles")
        } catch {
            throw error
        }
    }
}
