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
    // MARK: - Properties
    private var viewModel: (LikedArticlesViewModelProtocol & LikedArticlesPersistentProtocol)
    
    // MARK: - UIElements
    private lazy var likedArticlesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
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
        viewModel.fetchLikedArticles()
        playLottieAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
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
        guard let url = URL(string: article.url) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    
    // MARK: - Actions
    @objc
    private func removeAllArticles() {
        viewModel.deleteAllArticles()
    }
    
    // MARK: - Configurational Methods
    private func setupUI() {
        setupNavigationController()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Remove all", image: nil, target: self, action: #selector(removeAllArticles))
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
