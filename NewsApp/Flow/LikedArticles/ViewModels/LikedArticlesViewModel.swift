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
    
    var isLocked: Bool { get }
    var secretStatus: LikedArticlesViewModel.SecretStatus { get set }
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

protocol LikedArticlesSecretProtocol {
    func fetchSecretArticles() 
}

class LikedArticlesViewModel: LikedArticlesViewModelProtocol, LikedArticlesPersistentProtocol, LikedArticlesSecretProtocol {
    // MARK: - Properties
    enum SecretStatus {
        case locked
        case unlocked
        
        var navIconImage: SystemAssets {
            switch self {
            case .locked:
                return .lock
            case .unlocked:
                return .unlocked
            }
        }
    }
    
    struct Section {
        let name: String
        let articles: [LikedArticleModel]
    }
    
    weak var controller: (AlertProtocol & LikedArticleProtocol)?
    weak var delegate: LikedArticlesNavigationProtocol?
    
    private var likedArticles: [NSManagedObject] = []
    private var likedarticlesSections = [Section]()
    var secretStatus: SecretStatus = .locked
    
    var isLocked: Bool {
        return PasscodeKit.enabled() && secretStatus == .locked
    }
    
    var numberOfSections: Int {
        likedarticlesSections.count
    }
    
    // MARK: - Methods
    private func createLikedArticlesSections() {
        likedarticlesSections = likedArticles.toSections()
    }
    
    private func appendToSections(secretArticles: [SecretArticle]) {
        likedarticlesSections += secretArticles.toSections()
    }
    
    func numberOfArticles(in section: Int) -> Int {
        likedarticlesSections[safe: section]?.articles.count ?? .zero
    }
    
    func titleForHeader(in section: Int) -> String {
        likedarticlesSections[safe: section]?.name ?? ""
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
        let article = getLikedArticle(for: indexPath)
        guard article.section == Constants.LikedViewController.secretSectionName else {
            deleteLikedArticle(at: indexPath)
            return
        }
        deleteSecretArticle(at: indexPath)
    }
    
    private func deleteLikedArticle(at indexPath: IndexPath) {
        LikedArticlePersistentService.shared.deleteArticle(with: getLikedArticle(for: indexPath)) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
            self?.fetchLikedArticles()
            if self?.secretStatus == .unlocked {
                self?.fetchSecretArticles()
            }
            self?.controller?.reloadTable()
        }
    }
    
    func deleteAllArticles() {
        LikedArticlePersistentService.shared.deleteAllArticles { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
            }
            self?.deleteAllSecretArticles()
            self?.fetchLikedArticles()
            self?.controller?.reloadTable()
        }
    }
    
    // MARK: - KeychainService methods
    func fetchSecretArticles() {
        ArticleKeychainService.shared.retrieveArticles { [weak self] result in
            switch result {
            case .success(let secretArticles):
                self?.appendToSections(secretArticles: secretArticles)
            case .failure(let error):
                self?.controller?.present(alert: .kCFethingIssue(message: error.localizedDescription))
            }
        }
    }
    
    private func deleteAllSecretArticles() {
        guard secretStatus == .unlocked else { return }
        ArticleKeychainService.shared.removeAll { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .kCDeletingIssue(message: error.localizedDescription))
            }
        }
    }
    
    func deleteSecretArticle(at indexPath: IndexPath) {
        ArticleKeychainService.shared.removeAt(index: indexPath.row) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .kCDeletingIssue(message: error.localizedDescription))
            }
            self?.fetchLikedArticles()
            self?.fetchSecretArticles()
            self?.controller?.reloadTable()
        }
    }
}

// MARK: - Extensions
fileprivate extension Array where Element == LikedArticleModel {
    func orderedDictionary(grouping keyPath: (Element) -> String) -> OrderedDictionary<String, [Element]> {
        return OrderedDictionary(grouping: self, by: keyPath)
    }
}

fileprivate extension Array where Element == NSManagedObject {
    func toSections() -> [LikedArticlesViewModel.Section] {
        self.compactMap {
            LikedArticleModel(title: $0.value(forKey: .title),
                              author: $0.value(forKey: .author),
                              url: $0.value(forKey: .url),
                              section: $0.value(forKey: .section))
        }
        .orderedDictionary {
            $0.section
        }
        .map { key, value in
            LikedArticlesViewModel.Section(name: key, articles: value)
        }
    }
}

fileprivate extension Array where Element == SecretArticle {
    func toSections() -> [LikedArticlesViewModel.Section] {
        self.compactMap {
            LikedArticleModel(title: $0.title,
                              author: $0.byline,
                              url: $0.url,
                              section: Constants.LikedViewController.secretSectionName)
        }
        .orderedDictionary {
            $0.section
        }
        .map { key, value in
            LikedArticlesViewModel.Section(name: key, articles: value)
        }
    }
}
