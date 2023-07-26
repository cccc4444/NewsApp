//
//  HomeCoordinator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 20.07.2023.
//

import Foundation
import UIKit

protocol HomeNavigationDelegate: AnyObject {
    func presentLikedArticles()
    func presentThemes()
    func presentPassCodeSettings()
    func presentArticleDetails(
        for article: DisplayableArticle,
        with homeViewModel: HomeViewModelProtocolAlias)
    func presentViperArticleDetails(
        for article: DisplayableArticle,
        with homeViewModel: HomeViewModelProtocolAlias)
    func presentVIPArticleDetails(
        for article: DisplayableArticle,
        with homeViewModel: HomeViewModelProtocolAlias)
}

class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.coordinator = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        self.navigationController.viewControllers = [homeViewController]
    }
}

extension HomeCoordinator: HomeNavigationDelegate {
    func presentLikedArticles() {
        let likedCoordinator = LikedArticlesCoordinator(navigationController: navigationController)
        likedCoordinator.delegate = self
        childCoordinators.append(likedCoordinator)
        likedCoordinator.start()
    }
    
    func presentThemes() {
        let themesCoordinator = ThemesCoordinator(navigationController: navigationController)
        themesCoordinator.start()
    }
    
    func presentArticleDetails(for article: DisplayableArticle, with homeViewModel: HomeViewModelProtocolAlias) {
        let articleDetailsCoordinator = ArticleDetailsCoordinator(
            navigationController: navigationController,
            homeViewModel: homeViewModel,
            article: article
        )
        childCoordinators.append(articleDetailsCoordinator)
        articleDetailsCoordinator.start()
    }
    
    func presentViperArticleDetails(for article: DisplayableArticle, with homeViewModel: HomeViewModelProtocolAlias) {
        let articleDetailsRouter = ArticleDetailsRouter(
            navigationController: navigationController,
            homeViewModel: homeViewModel,
            article: article)
        childCoordinators.append(articleDetailsRouter)
        articleDetailsRouter.start()
    }
    
    func presentVIPArticleDetails(for article: DisplayableArticle, with homeViewModel: HomeViewModelProtocolAlias) {
        let vipDetailsRouter = VIPArticleDetailsRouter(
            navigationController: navigationController,
            homeViewModel: homeViewModel,
            article: article)
        childCoordinators.append(vipDetailsRouter)
        vipDetailsRouter.start()
    }
    
    func presentPassCodeSettings() {
        let passcodeSettingsCoordinator = PasscodeSettingsCoordinator(navigationController: navigationController)
        passcodeSettingsCoordinator.start()
    }
}

extension HomeCoordinator: BackToHomeViewControllerDelegate {
    func navigateBackToHomePage(newOrderCoordinator: LikedArticlesCoordinator) {
        navigationController.popToRootViewController(animated: true)
        childCoordinators.removeLast()
    }
}
