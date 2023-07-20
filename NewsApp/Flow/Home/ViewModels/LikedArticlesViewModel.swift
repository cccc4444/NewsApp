//
//  LkedArticlesViewMode.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation
import CoreData
import OrderedCollections

protocol LikedArticlesNavigationProtocol: AnyObject {
    func presentArticle(at url: String)
}

protocol LikedArticlesViewModelProtocol {
    var controller: (AlertProtocol & LikedArticleProtocol)? { get set }
    var delegate: LikedArticlesNavigationProtocol? { get set }
    
    var numberOfSections: Int { get }
    func getLikedArticle(for indexPath: IndexPath) -> LikedArticleModel
    func titleForHeader(in section: Int) -> String
    func numberOfArticles(in section: Int) -> Int
}

protocol LikedArticlesPersistentProtocol {
    func fetchLikedArticles()
    func deleteArticle(for indexPath: IndexPath)
    func deleteAllArticles()
}

class LikedArticlesViewModel: LikedArticlesViewModelProtocol, LikedArticlesPersistentProtocol {
    // MARK: - Properties
    struct Section {
        let name: String
        let articles: [LikedArticleModel]
    }
    
    weak var controller: (AlertProtocol & LikedArticleProtocol)?
    weak var delegate: LikedArticlesNavigationProtocol?
    
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
    
    func titleForHeader(in section: Int) -> String {
        likedarticlesSections[safe: section]?
            .name ?? ""
    }
    
    func getLikedArticle(for indexPath: IndexPath) -> LikedArticleModel {
        likedarticlesSections[safe: indexPath.section]?.articles[safe: indexPath.row] ?? .empty
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
    
    func deleteArticle(for indexPath: IndexPath) {
        LikedArticlePersistentService.shared.deleteArticle(with: getLikedArticle(for: indexPath)) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
            self?.fetchLikedArticles()
            self?.controller?.reloadTable()
        }
    }
    
    func deleteAllArticles() {
        LikedArticlePersistentService.shared.deleteAllArticles { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
            self?.fetchLikedArticles()
            self?.controller?.reloadTable()
        }
    }
}

fileprivate extension Array where Element == LikedArticleModel {
    func orderedDictionary(grouping keyPath: (Element) -> String) -> OrderedDictionary<String, [Element]> {
        return OrderedDictionary(grouping: self, by: keyPath)
    }
}
