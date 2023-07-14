//
//  LkedArticlesViewMode.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation
import CoreData

protocol LikedArticlesViewModelProtocol {
    var controller: AlertProtocol? { get set }
    func getLikedArticles() -> [LikedArticleModel?]
}

class LikedArticlesViewModel: LikedArticlesViewModelProtocol {
    
    // MARK: - Properties
    weak var controller: AlertProtocol?
    private var likedArticles: [NSManagedObject] = []
    
    // MARK: - Initializsers
    init() {
        fetchLikedArticles()
    }
    
    // MARK: - Methods
    func getLikedArticles() -> [LikedArticleModel?] {
        return likedArticles.map {
            .init(title: $0.value(forKey: .title),
                  author: $0.value(forKey: .author),
                  url: $0.value(forKey: .url))
        }
    }
    
    // MARK: - Persistent Methods
    private func fetchLikedArticles() {
        LikedArtickePersistentService.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let managedObjects):
                self?.likedArticles = managedObjects
            case .failure(let error):
                self?.controller?.present(alert: .coreDataFetchingIssue(message: error.localizedDescription))
            }
        }
    }
    
    private func deleteAllArticles() {
        LikedArtickePersistentService.shared.deleteAllArticles { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
        }
    }
}
