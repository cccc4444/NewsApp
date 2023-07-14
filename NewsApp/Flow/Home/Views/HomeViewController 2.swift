//
//  ViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import UIKit
import SnapKit
import Combine

protocol HomeViewContollerProtocol: AnyObject {
    func reloadTableData()
    func endRefreshing()
}

class HomeViewController: UIViewController, HomeViewContollerProtocol {
    
    // MARK: - UI Elements
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private lazy var sectionNavButton: UIButton = {
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
    
    private lazy var storiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    
    private var viewModel: HomeViewModelProtocol = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        trackSections()
        trackMostViewedStories()
        
        viewModel.fetchMostViewedStories(refresh: false)
        viewModel.fetchStoriesSections()
        
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        activityIndicator.startAnimating()
        storiesTableView.backgroundView = activityIndicator
        storiesTableView.refreshControl?.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
    }
    
    @objc private func refreshControlAction() {
        viewModel.fetchMostViewedStories(refresh: true)
    }
    
    private func trackSections() {
        viewModel.sectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupSectionButton()
            }
            .store(in: &cancellables)
    }
    
    private func trackMostViewedStories() {
        viewModel.mostViewedStoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storiesTableView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
    }
    
    private func setupSectionButton() {
        sectionNavButton.menu = UIMenu(
            children: { viewModel
                .sections
                .map { sectionName in
                    UIAction(
                        title: "\(sectionName)",
                        image: UIImage(systemName: Constants.HomeViewController.Sections.sectionListIcons[sectionName] ?? "")
                    ) { [weak self] _ in
                        self?.sectionNavButton.setTitle(sectionName, for: .normal)
                        self?.viewModel.fetchStories(for: sectionName.withLowercasedFirstLetter, refresh: false)
                    }
                }
            }()
        )
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.storiesTableView.reloadData()
        }
    }
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.storiesTableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Configurational methods
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = sectionNavButton
        setupVacationsTableView()
    }
    
    private func setupVacationsTableView() {
        view.addSubview(storiesTableView)
        storiesTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableView

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.mostViewdStoriesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = viewModel.getArticle(for: indexPath)
        let cell: StoriesTableViewCell = tableView.dequeueCell()
        cell.setup(model: article)
        return cell
    }
}

