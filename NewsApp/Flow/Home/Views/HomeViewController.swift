//
//  ViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import UIKit
import SnapKit
import Combine
import NotificationBannerSwift

protocol HomeViewContollerProtocol: AnyObject {
    func reloadTableData()
    func endRefreshing()
    func showLikeWarning()
}

class HomeViewController: UIViewController, HomeViewContollerProtocol {
    
    // MARK: - UI Elements
    
    private lazy var refreshControl: UIRefreshControl = {
        var control = UIRefreshControl()
        control.layer.zPosition = -1
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    
    private lazy var sectionNavButton: UIButton = {
        var configuration = UIButton.Configuration.borderless()
        configuration.title = Constants.HomeViewController.defaultSectionName
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
    
    private var viewModel: (HomeViewModelProtocol & HomeViewModelNetworkingProtocol & HomeViewPersistentProtocol) = HomeViewModel()
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        setupUI()
        
        trackSections()
        trackMostViewedStories()
        trackGeneralStories() 
        
        viewModel.fetchMostViewedStories()
        viewModel.fetchStoriesSections()
    }
    
    private func trackSections() {
        viewModel.sectionsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.setupSectionActions()
            }
            .store(in: &cancellables)
    }
    
    private func trackMostViewedStories() {
        viewModel.mostViewedStoriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storiesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func trackGeneralStories() {
        viewModel.sectionStoriesViewModelPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storiesTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupSectionActions() {        
        sectionNavButton.menu = UIMenu(
            children: viewModel.sections
                .flatMap { createActionForSection($0) }
        )
    }
    
    private func createActionForSection(_ section: HomeViewModel.SectionType) -> [UIAction] {
        switch section {
        case let .top(name):
            return [UIAction(
                title: "\(name)",
                image: UIImage(systemNamed: .top)
            ) { [weak self] _ in
                self?.setNavButton(name: name)
                self?.setViewModel(section, sectionName: name)
            }]
        case let .general(sectionNames):
            return sectionNames.map { name in
                return UIAction(
                    title: "\(name)",
                    image: UIImage(systemName: Constants.HomeViewController.Sections.sectionListIcons[name] ?? "")
                ) { [weak self] _ in
                    self?.setNavButton(name: name)
                    self?.setViewModel(section, sectionName: name)
                }
            }
        }
    }
    
    private func setNavButton(name: String) {
        sectionNavButton.setTitle(name, for: .normal)
    }
    
    private func setViewModel(_ section: HomeViewModel.SectionType, sectionName: String) {
        viewModel.selectedSectionType = section
        viewModel.setSelectedSectionName(sectionName)
        viewModel.setSectionAction()
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.storiesTableView.reloadData()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showLikeWarning() {
        let banner = NotificationBanner(title: "Hey", subtitle: "Reconsider your life choices!", style: .warning)
        banner.show()
    }
    
    // MARK: - Actions
    
    @objc
    private func refresh() {
        viewModel.refreshStories()
    }
    
    @objc
    private func displayLikedArticles() {
        let viewModel = LikedArticlesViewModel()
        let likedVC = LikedArticlesViewController(viewModel: viewModel)
        super.navigationController?.pushViewController(likedVC, animated: true)
    }
    
    // MARK: - Configurational methods
    
    private func setupUI() {
        view.backgroundColor = .white
        setupNavigationController()
        setupVacationsTableView()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = sectionNavButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemNamed: .like), style: .plain, target: self, action: #selector(displayLikedArticles))
    }
    
    private func setupVacationsTableView() {
        view.addSubview(storiesTableView)
        storiesTableView.addSubview(refreshControl)
        
        sectionNavButton.snp.makeConstraints { make in
            make.width.equalTo(30)
        }
        
        storiesTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - UITableView

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.storiesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = viewModel.getArticle(for: indexPath)
        let cell: StoriesTableViewCell = tableView.dequeueCell()
        cell.setup(model: article)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let article = viewModel.getArticle(for: indexPath) else { return }
        let viewModel = DetailViewModel(homeViewModel: viewModel, article: article)
        let detailVC = DetailViewController(viewModel: viewModel)
        super.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let archive = UIContextualAction(style: .normal,
                                         title: "Archive") { [weak self] (_, _, completionHandler) in
            self?.viewModel.likeArticle(at: indexPath)
            completionHandler(true)
        }
        archive.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [archive])
    }
}
