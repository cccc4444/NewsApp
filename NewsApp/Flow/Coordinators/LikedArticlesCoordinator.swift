//
//  LikedArticlesCoordinator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 20.07.2023.
//

import Foundation
import UIKit
import SafariServices

protocol BackToHomeViewControllerDelegate: AnyObject {
    func navigateBackToHomePage(newOrderCoordinator: LikedArticlesCoordinator)
}

protocol LikedArticlesNavigationProtocol: AnyObject {
    func presentArticle(at url: String)
}

class LikedArticlesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: BackToHomeViewControllerDelegate?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = LikedArticlesViewModel()
        viewModel.coordinator = self
        let likedVC = LikedArticlesViewController(viewModel: viewModel)
        navigationController.pushViewController(likedVC, animated: true)
    }
}

// MARK: - Delegate Methods
extension LikedArticlesCoordinator: LikedArticlesNavigationProtocol {
    func presentArticle(at url: String) {
        guard let url = URL(string: url) else { return }
        navigationController.present(SFSafariViewController(url: url), animated: true)
    }
}
