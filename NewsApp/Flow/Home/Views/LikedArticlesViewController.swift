//
//  LikedArticlesViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import UIKit
import Lottie
import SafariServices

protocol LikedArticleProtocol {
    func reloadTable()
}

class LikedArticlesViewController: UIViewController, LikedArticleProtocol {
    // MARK: - UIElements
    private lazy var likedArticlesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        tableView.backgroundColor = .systemGray6
        return tableView
    }()

    private lazy var emptyStateAnimationView: LottieAnimationView = {
        var animationView: LottieAnimationView = .init(name: "animationBlack.json")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        animationView.isHidden = true
        return animationView
    }()
    
    // MARK: - Properties
    enum SecretStatus {
        case locked
        case unlocked
        
        var navIconImage: SystemAssets {
            switch self {
            case .locked:
                return .lock
            case .unlocked:
                return .unlocked
            }
        }
    }
    
    private var viewModel: (LikedArticlesViewModelProtocol & LikedArticlesPersistentProtocol)
    
    private var navigationItems: [UIBarButtonItem] {
        let removeAll = UIBarButtonItem(title: "Remove all", image: nil, target: self, action: #selector(removeAllArticles))
        let secretArticles = UIBarButtonItem(image: UIImage(systemNamed: secretStatus.navIconImage), style: .plain, target: self, action: #selector(lockTapped))
        
        if PasscodeKit.enabled() {
            return [removeAll, secretArticles]
        }
        return [removeAll]
    }
    
    private var secretStatus: SecretStatus = .locked
    
    // MARK: - Initializers
    init(viewModel: (LikedArticlesViewModelProtocol & LikedArticlesPersistentProtocol)) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
        viewModel.fetchLikedArticles()
        playLottieAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        PasscodeKit.delegate = self
        setupUI()
    }
    
    func reloadTable() {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeInOut, animations: { [self] in
            likedArticlesTableView.reloadData()
        })
        .startAnimation()
        playLottieAnimation()
    }
    
    private func playLottieAnimation() {
        if viewModel.numberOfSections == .zero {
            view.show(emptyStateAnimationView)
            emptyStateAnimationView.play()
        } else {
            view.hide(emptyStateAnimationView)
            emptyStateAnimationView.stop()
        }
    }
    
    func articleTapped(article: LikedArticleModel) {
        viewModel.delegate?.presentArticle(at: article.url)
    }
    
    @objc
    private func lockTapped() {
        PasscodeKit.shared.verifyPasscode()
    }
    
    // MARK: - Actions
    @objc
    private func removeAllArticles() {
        viewModel.deleteAllArticles()
    }
    
    // MARK: - Configurational Methods
    private func setupUI() {
        view.backgroundColor = .systemGray
        setupTableView()
        setupEmptyStateAnimationView()
    }

    private func setupEmptyStateAnimationView() {
        view.addSubview(emptyStateAnimationView)
        emptyStateAnimationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Favourites"
        navigationItem.titleView?.tintColor = .blackWhite
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItems = navigationItems
    }
    
    private func setupTableView() {
        view.addSubview(likedArticlesTableView)
        likedArticlesTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - TableView
extension LikedArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfArticles(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LikedArticleTableViewCell = tableView.dequeueCell()
        cell.setup(model: viewModel.getLikedArticle(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trash = UIContextualAction(style: .destructive,
                                       title: "Remove") { [weak self] (_, _, completionHandler)  in
            self?.viewModel.deleteArticle(for: indexPath)
            completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [trash])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        articleTapped(article: viewModel.getLikedArticle(for: indexPath))
    }
}

// MARK: - PasscodeKitDelegate
extension LikedArticlesViewController: PasscodeKitDelegate {
    func passcodeCheckedButDisabled() {
        print(#function)
    }
    
    func passcodeEnteredSuccessfully() {
        secretStatus = .unlocked
    }
    
    func passcodeMaximumFailedAttempts() {
        print(#function)
    }
}
