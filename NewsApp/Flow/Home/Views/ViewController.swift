//
//  ViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import UIKit
import SnapKit
import Observation

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var centerNavigationButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.title = Constants.HomeViewController.navBarButtonDefaultName
        configuration.baseForegroundColor = .black
        configuration.image = UIImage(named: .chevron)
        configuration.titlePadding = Constants.HomeViewController.navBarTitlePadding
        configuration.imagePadding = Constants.HomeViewController.navBarImagePadding
        
        let button = UIButton(configuration: configuration)
        button.showsMenuAsPrimaryAction = true
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModelProtocol = HomeViewModel()

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        track()
        viewModel.fetchStoriesSections()
    }
    
    private func track() {
        withObservationTracking {
            let _ = self.viewModel.sections
        } onChange: {
            Task {
                @MainActor [weak self] in
                self?.setupNavBarButton()
            }
        }
    }
    
    private func setupNavBarButton() {
        centerNavigationButton.menu = UIMenu(title: "", children: { viewModel
            .sections
            .map {
                UIAction(
                    title: "\($0)",
                    image: UIImage(systemName: "heart.fill")) { _ in
                    }
            }}())
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = centerNavigationButton
    }
}
