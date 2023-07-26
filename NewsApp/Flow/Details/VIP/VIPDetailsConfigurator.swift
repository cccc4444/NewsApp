//
//  VIPDetailsConfigurator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit

protocol VIPDetailConfiguratorProtocol {
    static func createDetailsModule(with router: VIPArticleDetailsRouterProtocol, homeViewModel: HomeViewModelProtocol, article: DisplayableArticle) -> UIViewController
}

class VIPDetailConfigurator: VIPDetailConfiguratorProtocol {
    static func createDetailsModule(with router: VIPArticleDetailsRouterProtocol, homeViewModel: HomeViewModelProtocol, article: DisplayableArticle) -> UIViewController {
        let presenter = VIPDetailsPresenter(homeViewModel: homeViewModel, article: article)
        let interactor = VIPDetailsInteractor(presenter: presenter)
        let controller = VIPDetailsViewController(interactor: interactor, router: router)
    
        presenter.controller = controller
        
        return controller
    }
}
