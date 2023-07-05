//
//  ViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import UIKit
import Combine
import SnapKit

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
    
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel = HomeViewModel()
    
    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchStoriesSections()
        bindSectionsViewModel()
    }
    
    private func bindSectionsViewModel() {
        viewModel.sectionListViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] sections in
                self?.setupNavBarButton()
            }.store(in: &cancellables)
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
