//
//  LikedArticlesViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import UIKit

class LikedArticlesViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: LikedArticlesViewModelProtocol
    
    // MARK: - UIElements
    private lazy var likedArticlesTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 50
        return tableView
    }()
    
    // MARK: - Initializers
    init(viewModel: LikedArticlesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchLikedArticles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        setupUI()
    }
    
    // MARK: - Configurational Methods
    
    private func setupUI() {
        self.view.backgroundColor = .white
        setupNavigationController()
        setupTableView()
    }
    
    private func setupNavigationController() {
        navigationItem.title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
