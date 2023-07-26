//
//  VIPDetailsPresenter.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit

protocol VIPDetailsPresenterProtocol {
    func interactor(didFailDeleteArticle: Error)
    func interactor(didFailSaveArticle: Error)
    
    func interactor(isArticlePresent: Bool)
    func interactor(isFailArticlePresent: Error)
    
    func performActionForArticle()
    
    var article: DisplayableArticle { get }
    var selectedArticleURL: String { get }
    var selectedSectionType: HomeViewModel.SectionType { get }
    var articleState: VIPDetailsPresenter.ArticleState { get set }
    var likedArticleStateImage: UIImage? { get }
    var largeMediaURL: String? { get }
    var mediaURL: String? { get }
    var publishedDate: String { get }
    var authors: String { get }
    var articleTitle: String { get }
    var articleDescription: String { get }
}

class VIPDetailsPresenter: VIPDetailsPresenterProtocol {
    // MARK: - Properties
    weak var controller: VIPPresenterOutput?
    
    enum ArticleState {
        case likedPressed
        case likeUnpressed
        
        var image: UIImage? {
            switch self {
            case .likedPressed: UIImage(systemNamed: .likePressed)
            case .likeUnpressed: UIImage(systemNamed: .liked)
            }
        }
        
        mutating func toggle() {
            switch self {
            case .likedPressed:
                self = .likeUnpressed
            case .likeUnpressed:
                self = .likedPressed
            }
        }
    }
    
    private var homeViewModel: HomeViewModelProtocol
    var article: DisplayableArticle
    var articleState: ArticleState = .likeUnpressed
    
    var selectedArticleURL: String {
        article.url
    }
    
    var selectedSectionType: HomeViewModel.SectionType {
        homeViewModel.selectedSectionType
    }
    
    var likedArticleStateImage: UIImage? {
        articleState.image
    }
    
    var largeMediaURL: String? {
        article.largeMediaURL
    }
    
    var mediaURL: String? {
        article.mediaURL
    }
    
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
        article.abstract
    }
    
    // MARK: - Initializers
    init(homeViewModel: HomeViewModelProtocol, article: DisplayableArticle) {
        self.homeViewModel = homeViewModel
        self.article = article
    }
    
    // MARK: - Methods
    func interactor(didFailDeleteArticle: Error) {
        let description = didFailDeleteArticle.localizedDescription
        controller?.presenter(didFailDeleteArticle: description)
    }
    
    func interactor(didFailSaveArticle: Error) {
        let description = didFailSaveArticle.localizedDescription
        controller?.presenter(didFailSaveArticle: description)
    }
    
    func interactor(isArticlePresent: Bool) {
        articleState = isArticlePresent ? .likedPressed : .likeUnpressed
    }
    
    func interactor(isFailArticlePresent: Error) {
        controller?.presenter(isFailArticlePresent: isFailArticlePresent.localizedDescription)
    }
    
    func performActionForArticle() {
        switch articleState {
        case .likedPressed:
            controller?.deleteArticle()
        case .likeUnpressed:
            controller?.saveArticle()
        }
        articleState.toggle()
    }
}
