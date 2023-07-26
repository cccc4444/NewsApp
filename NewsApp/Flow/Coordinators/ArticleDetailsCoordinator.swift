//
//  ArticleDetailsCoordinator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 20.07.2023.
//

import Foundation
import UIKit
import SafariServices

class ArticleDetailsCoordinator: Coordinator {
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
        let viewModel = DetailViewModel(homeViewModel: homeViewModel, article: article)
        viewModel.coordinator = self
        let detailVC = DetailViewController(viewModel: viewModel)
        navigationController.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Delegate Methods
extension ArticleDetailsCoordinator: DetailNavigationProtocol {
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
