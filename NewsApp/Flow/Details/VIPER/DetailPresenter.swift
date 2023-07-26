//
//  DetailPresenter.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit

protocol DetailPresenterProtocol: AnyObject {
    var selectedSectionType: HomeViewModel.SectionType? { get }
    var articleLikedState: DetailPresenter.ArticleState { get }
    var publishedDate: String { get }
    var authors: String { get }
    var articleTitle: String { get }
    var articleDescription: String { get }
    var largeMediaURL: String? { get }
    var mediaURL: String? { get }
    
    func notifyViewDidLoad()
    func deleteArticle()
    func saveArticle()
    func perforActionForArticle()
    
    func navigateToArticle()
    func navigateToShareScreen()
}

class DetailPresenter {
    private weak var controller: (VDetailViewControllerProtocol & AlertProtocol)?
    private var interactor: DetailInteractorProtocol?
    private var router: ArticleDetailsRouter?
    
    private var homeViewModel: HomeViewModelProtocol
    private var article: DisplayableArticle
    
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
    
    init(controller: (VDetailViewControllerProtocol & AlertProtocol)?,
         interactor: DetailInteractorProtocol?,
         router: ArticleDetailsRouter?,
         homeViewModel: HomeViewModelProtocol,
         article: DisplayableArticle) {
        self.controller = controller
        self.interactor = interactor
        self.router = router
        self.homeViewModel = homeViewModel
        self.article = article
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    var publishedDate: String {
        article.publishedDate.formatted
    }
    
    var authors: String {
        article.byline
    }
    
    var articleTitle: String {
        article.title
    }
    
    var articleDescription: String {
        articleTitle.description
    }
    
    var selectedSectionType: HomeViewModel.SectionType? {
        homeViewModel.selectedSectionType
    }
    
    var largeMediaURL: String? {
        article.largeMediaURL
    }
    
    var mediaURL: String? {
        article.mediaURL
    }
    
    var articleLikedState: ArticleState {
        var articleState: ArticleState = .likeUnpressed
        interactor?.isArticleSaved(article, completion: { [weak self] result in
            switch result {
            case .success(let isSaved):
                articleState = isSaved ? .likedPressed : .likeUnpressed
            case .failure(let error):
                self?.controller?.present(alert: .coreDataCheckingForPresenceIssue(message: error.localizedDescription))
            }
        })
        return articleState
    }
    
    func notifyViewDidLoad() {
        controller?.setupUIElements()
        controller?.setupNavigationBarAppearance()
        controller?.setupUI()
    }
    
    func perforActionForArticle() {
        switch articleLikedState {
        case .likedPressed: deleteArticle()
        case .likeUnpressed: saveArticle()
        }
    }
    
    func deleteArticle() {
        interactor?.deleteArticle(article, completion: { [weak self] error in
            self?.controller?.present(alert: .coreDataDeletionIssue(message: error))
        })
    }
    
    func saveArticle() {
        interactor?.saveArticle(article, completion: { [weak self] error in
            self?.controller?.present(alert: .coreDataSavingIssue(message: error))
        })
    }
    
    func navigateToArticle() {
        router?.presentArticle(at: article.url)
    }
    
    func navigateToShareScreen() {
        router?.presentShareScreen(with: article.url)
    }
}
