//
//  KeycChainService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 21.07.2023.
//

import Foundation
import Security
import SimpleKeychain

protocol KeychainServiceInterface {
    func store(article: SecretArticle) throws
    func retrieveArticles() -> [SecretArticle]
    func remove() throws
}

class ArticleKeychainService: KeychainServiceInterface {
    
    static let shared = ArticleKeychainService()
    
    func store(article: SecretArticle) {
        do {
            var existingArticles = retrieveArticles()
            existingArticles.append(article)
            let data = try JSONEncoder().encode(existingArticles)
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            try keychain.set(data, forKey: "articles")
        } catch {
            print("Error storing article in keychain: \(error.localizedDescription)")
        }
    }
    
    func retrieveArticles() -> [SecretArticle] {
        do {
            let keychain = SimpleKeychain(service: "serviceIdentifier")
            let isStored = try keychain.hasItem(forKey: "articles")
            if isStored == false {
                return []
            }
            
            let data = try keychain.data(forKey: "articles")
            let articles = try JSONDecoder().decode([SecretArticle].self, from: data)
            return articles
        } catch {
            print("Error retrieving articles from keychain: \(error.localizedDescription)")
            return []
        }
    }
    
    func remove() throws {
//        let simpleKeychain = SimpleKeychain(service: Localizable.Keychain.auth0Service)
//        do {
//            try simpleKeychain.deleteItem(forKey: Localizable.Keychain.auth0AccessTokenAccount)
//        } catch let error as SimpleKeychainError {
//            throw error
//        }
    }
}
