//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 10.07.2023.
//

import UIKit

class DetailViewController: UIViewController {
    // MARK: - Properies
    private var viewModel: DetailViewModelProtocol
    
    // MARK: - UIElements
    
    private lazy var articleCollectionView: UICollectionView = {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight / 12)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: Constants.DetailViewController.articleDetailsReuseIdentifier)
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: Constants.DetailViewController.articleInfoReuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Metods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupNavigationBarAppearance()
        setupArticleCollectionView()
    }
    
    // MARK: - Configurational Methods
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .black
    }

    private func setupArticleCollectionView() {
        view.addSubview(articleCollectionView)
        
        articleCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfItemsInSections
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell: InfoCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(data: viewModel.article)
            return cell
        default:
            let cell: DetailCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(data: viewModel.article, articleType: viewModel.selectedSectionType)
            return cell
        }
    }
}
