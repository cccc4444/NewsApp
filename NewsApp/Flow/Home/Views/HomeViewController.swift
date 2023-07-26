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

typealias HomeViewModelProtocolAlias = (HomeViewModelNetworkingProtocol & HomeViewModelProtocol & HomeViewPersistentProtocol)

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
        configuration.baseForegroundColor = .blackWhite
        configuration.image = UIImage(named: .chevron)?.withTintColor(.blackWhite)
        configuration.titlePadding = Constants.HomeViewController.navBarTitlePadding
        configuration.imagePadding = Constants.HomeViewController.navBarImagePadding
        
        let button = UIButton(configuration: configuration)
        button.showsMenuAsPrimaryAction = true
        button.semanticContentAttribute = .forceRightToLeft
        return button
    }()
    
    private lazy var storiesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Properties
    private var viewModel: HomeViewModelProtocolAlias
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    init(viewModel: HomeViewModelProtocol & HomeViewModelNetworkingProtocol & HomeViewPersistentProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let banner = NotificationBanner(title: Constants.NotificationBannerConstants.title, subtitle: Constants.NotificationBannerConstants.subtitle, style: .warning)
        banner.show()
    }
    
    private func setTableTrailingActions(indexPath: IndexPath) -> UISwipeActionsConfiguration {
        let archive = UIContextualAction(
            style: .normal,
            title: Constants.HomeViewController.trailingArchieveActionTitle) { [weak self] (_, _, completionHandler) in
                self?.viewModel.likeArticle(at: indexPath)
                completionHandler(true)
        }
        
        let secret = UIContextualAction(
            style: .normal,
            title: Constants.HomeViewController.trailingSecretActionTitle) { [weak self] (_, _, completionHandler) in
                self?.viewModel.likeSecretArticle(at: indexPath)
                completionHandler(true)
        }
        archive.backgroundColor = .systemGreen
        secret.backgroundColor = .systemGray
        return UISwipeActionsConfiguration(actions: [archive, secret])
    }
    
    // MARK: - Actions
    @objc
    private func refresh() {
        viewModel.refreshStories()
    }
    
    @objc
    private func displayLikedArticles() {
        viewModel.coordinator?.presentLikedArticles()
    }
    
    @objc
    private func displayThemesScreen() {
        viewModel.coordinator?.presentThemes()
    }
    
    @objc
    private func displayPassCodeSettings() {
        viewModel.coordinator?.presentPassCodeSettings()
    }
    
    // MARK: - Configurational methods
    private func setupUI() {
        view.backgroundColor = .systemGray6
        setupNavigationController()
        setupVacationsTableView()
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.tintColor = .blackWhite
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.titleView = sectionNavButton
        let likedArticles = UIBarButtonItem(image: UIImage(systemNamed: .like), style: .plain, target: self, action: #selector(displayLikedArticles))
        let theme = UIBarButtonItem(image: UIImage(systemNamed: .theme), style: .plain, target: self, action: #selector(displayThemesScreen))
        let passCodeSettings = UIBarButtonItem(image: UIImage(systemNamed: .gear), style: .plain, target: self, action: #selector(displayPassCodeSettings))
        navigationItem.rightBarButtonItem = likedArticles
        navigationItem.leftBarButtonItems = [passCodeSettings, theme]
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
        viewModel.coordinator?.presentArticleDetails(for: article, with: viewModel)
//        viewModel.coordinator?.presentViperArticleDetails(for: article, with: viewModel)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        setTableTrailingActions(indexPath: indexPath)
    }
}
