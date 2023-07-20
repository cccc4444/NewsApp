//
//  ThemesCoordinator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 20.07.2023.
//

import Foundation
import UIKit

class ThemesCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let themesVc = ThemeViewController()
        let nav = UINavigationController(rootViewController: themesVc)
        let fraction = UISheetPresentationController.Detent.custom(resolver: { _ in 100 })
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [fraction]
        }
        nav.modalPresentationStyle = .pageSheet
        navigationController.present(nav, animated: true, completion: nil)
    }
}
