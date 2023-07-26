//
//  ArticleDetailsRouter.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit
import SafariServices

protocol ArticleDetailsRouterProtocol: AnyObject {
    func presentShareScreen(with url: String)
    func presentArticle(at url: String)
}

class ArticleDetailsRouter: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var homeViewModel: HomeViewModelProtocolAlias?
    var article: DisplayableArticle?
    
    init(navigationController: UINavigationController, homeViewModel: HomeViewModelProtocolAlias, article: DisplayableArticle) {
        self.navigationController = navigationController
        self.homeViewModel = homeViewModel
        self.article = article
    }
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let homeViewModel, let article else { return }
        let controller = DetailAssembly.createDetailsModule(with: self, homeViewModel: homeViewModel, article: article)
        navigationController.pushViewController(controller, animated: true)
    }
}

extension ArticleDetailsRouter: ArticleDetailsRouterProtocol {
    func presentShareScreen(with url: String) {
        let items = [URL(string: url)]
        let activity = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        navigationController.present(activity, animated: true)
    }
    
    func presentArticle(at url: String) {
        guard let url = URL(string: url) else { return }
        navigationController.present(SFSafariViewController(url: url), animated: true)
    }
}
