//
//  VIPDetailsInteractor.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit

protocol VIPDetailsInteractorProtocol {
    func deleteArticle()
    func saveArticle()
    func isArticleSaved()
    func setArticleState(_ articleState: VIPDetailsPresenter.ArticleState)
    func performActionForArticle()
    
    var selectedArticleURL: String { get }
    var likedArticleStateImage: UIImage? { get }
    var largeMediaURL: String? { get }
    var mediaURL: String? { get }
    var publishedDate: String { get }
    var authors: String { get }
    var articleTitle: String { get }
    var articleDescription: String { get }
    var selectedSectionType: HomeViewModel.SectionType { get }
}

class VIPDetailsInteractor: VIPDetailsInteractorProtocol {
    // MARK: - Properties
    var presenter: VIPDetailsPresenterProtocol
    
    private var article: DisplayableArticle {
        presenter.article
    }
    
    var likedArticleStateImage: UIImage? {
        presenter.likedArticleStateImage
    }
    
    var selectedArticleURL: String {
        presenter.selectedArticleURL
    }
    
    var largeMediaURL: String? {
        presenter.largeMediaURL
    }
    
    var mediaURL: String? {
        presenter.mediaURL
    }
    
    var selectedSectionType: HomeViewModel.SectionType {
        presenter.selectedSectionType
    }
    
    var publishedDate: String {
        presenter.publishedDate
    }
    
    var authors: String {
        presenter.authors
    }
    
    var articleTitle: String {
        presenter.articleTitle
    }
    
    var articleDescription: String {
        presenter.articleDescription
    }
    
    // MARK: - Initializers
    init(presenter: VIPDetailsPresenterProtocol) {
        self.presenter = presenter
    }
    
    // MARK: - Methods
    func setArticleState(_ articleState: VIPDetailsPresenter.ArticleState) {
        self.presenter.articleState = articleState
    }
    
    func performActionForArticle() {
        self.presenter.performActionForArticle()
    }
    
    func deleteArticle() {
        LikedArticlePersistentService.shared.deleteArticle(with: article) { [unowned self] result in
            if case let .failure(error) = result {
                self.presenter.interactor(didFailDeleteArticle: error)
                return
            }
        }
    }
    
    func saveArticle() {
        LikedArticlePersistentService.shared.saveArticle(with: article) { [unowned self] result in
            if case let .failure(error) = result {
                self.presenter.interactor(didFailSaveArticle: error)
                return
            }
        }
    }
    
    func isArticleSaved() {
        LikedArticlePersistentService.shared.isArticleSaved(with: article) { [unowned self] result in
            switch result {
            case .success(let isSaved):
                self.presenter.interactor(isArticlePresent: isSaved)
            case .failure(let error):
                self.presenter.interactor(isFailArticlePresent: error)
            }
        }
    }
}
