//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 10.07.2023.
//

import Foundation
import UIKit
import CoreData

protocol DetailViewModelProtocol {
    var controller: AlertProtocol? { get set }
    var coordinator: DetailNavigationProtocol? { get set }
    
    var article: DisplayableArticle { get }
    var selectedSectionType: HomeViewModel.SectionType? { get }
    var selectedArticleURL: String { get }
    var articleLikedState: DetailViewModel.ArticleState { get }
    
    func perforActionForArticle()
}

class DetailViewModel: DetailViewModelProtocol {
    // MARK: - Properties
    enum ArticleState {
        case likedPressed
        case likeUnpressed
        
        var image: UIImage? {
            switch self {
            case .likedPressed: UIImage(systemNamed: .likePressed)
            case .likeUnpressed: UIImage(systemNamed: .liked)
            }
        }
    }
    
    weak var controller: AlertProtocol?
    weak var homeViewModel: (HomeViewModelProtocol & HomeViewModelNetworkingProtocol)?
    weak var coordinator: DetailNavigationProtocol?
    
    var article: DisplayableArticle
    
    var selectedSectionType: HomeViewModel.SectionType? {
        homeViewModel?.selectedSectionType
    }
    
    var selectedArticleURL: String {
        article.url
    }
    
    var articleLikedState: ArticleState {
        var articleState: ArticleState = .likeUnpressed
        LikedArticlePersistentService.shared.isArticleSaved(with: article) { [weak self] result in
            switch result {
            case .success(let isSaved):
                articleState = isSaved ? .likedPressed : .likeUnpressed
            case .failure(let error):
                self?.controller?.present(alert: .coreDataCheckingForPresenceIssue(message: error.localizedDescription))
            }
        }
        return articleState
    }
    
    // MARK: - Initializers
    init(homeViewModel: (HomeViewModelProtocol & HomeViewModelNetworkingProtocol)? = nil, article: DisplayableArticle) {
        self.homeViewModel = homeViewModel
        self.article = article
    }
    
    // MARK: - Methods
    func perforActionForArticle() {
        switch articleLikedState {
        case .likedPressed: deleteArticle()
        case .likeUnpressed: saveArticle()
        }
    }
    
    // MARK: - Persistent Methods
    private func deleteArticle() {
        LikedArticlePersistentService.shared.deleteArticle(with: article) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataDeletionIssue(message: error.localizedDescription))
                return
            }
        }
    }
    
    private func saveArticle() {
        LikedArticlePersistentService.shared.saveArticle(with: article) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataSavingIssue(message: error.localizedDescription))
                return
            }
        }
    }
}
