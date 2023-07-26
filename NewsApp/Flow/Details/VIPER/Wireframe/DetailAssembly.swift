//
//  VDetailAssembly.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation
import UIKit

protocol DetailAssemblyProtocol {
    static func createDetailsModule(with router: ArticleDetailsRouterProtocol, homeViewModel: HomeViewModelProtocol, article: DisplayableArticle) -> UIViewController
}

class DetailAssembly: DetailAssemblyProtocol {
    static func createDetailsModule(with router: ArticleDetailsRouterProtocol, homeViewModel: HomeViewModelProtocol, article: DisplayableArticle) -> UIViewController {
        let controller = VDetailViewController()
        let interactor = DetailInteractor()
        let presenter = DetailPresenter(controller: controller, interactor: interactor, router: router, homeViewModel: homeViewModel, article: article)
        controller.presenter = presenter
        
        return controller
    }
}
