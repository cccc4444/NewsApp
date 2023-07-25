//
//  PasscodeSettingsCoordinator.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 25.07.2023.
//

import Foundation
import UIKit

class PasscodeSettingsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let passcodeVC = ViewController(nibName: "ViewController", bundle: nil)
        navigationController.pushViewController(passcodeVC, animated: true)
    }
}
