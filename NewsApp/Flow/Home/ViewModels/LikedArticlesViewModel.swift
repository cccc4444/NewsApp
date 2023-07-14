//
//  LkedArticlesViewMode.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation
import CoreData
import OrderedCollections

protocol LikedArticlesViewModelProtocol {
    var controller: AlertProtocol? { get set }
    var numberOfSections: Int { get }
    
    func numberOfArticles(in section: Int) -> Int
    func fetchLikedArticles()
}

class LikedArticlesViewModel: LikedArticlesViewModelProtocol {
    // MARK: - Properties
    struct Section {
        let name: String
        let articles: [LikedArticleModel]
    }
    
    weak var controller: AlertProtocol?
    private var likedArticles: [NSManagedObject] = []
    private var likedarticlesSections = [Section]()
    
    var numberOfSections: Int {
        likedarticlesSections.count
    }
    
    // MARK: - Methods
    func createLikedArticlesSections() {
        likedarticlesSections = likedArticles.compactMap {
            LikedArticleModel(title: $0.value(forKey: .title),
                              author: $0.value(forKey: .author),
                              url: $0.value(forKey: .url),
                              section: $0.value(forKey: .section))
        }
        .orderedDictionary {
            $0.section
        }
        .map { key, value in
            Section(name: key, articles: value)
        }
    }
    
    func numberOfArticles(in section: Int) -> Int {
        likedarticlesSections[safe: section]?
            .articles.count ?? .zero
    }
    
    // MARK: - Persistent Methods
    func fetchLikedArticles() {
        LikedArticlePersistentService.shared.fetchArticles { [weak self] result in
            switch result {
            case .success(let managedObjects):
                self?.likedArticles = managedObjects
                self?.createLikedArticlesSections()
            case .failure(let error):
                self?.controller?.present(alert: .coreDataFetchingIssue(message: error.localizedDescription))
            }
        }
    }
    
    private func deleteAllArticles() {
        LikedArticlePersistentService.shared.deleteAllArticles { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
        }
    }
}

fileprivate extension Array where Element == LikedArticleModel {
    func orderedDictionary(grouping keyPath: (Element) -> String) -> OrderedDictionary<String, [Element]> {
        return OrderedDictionary(grouping: self, by: keyPath)
    }
}
