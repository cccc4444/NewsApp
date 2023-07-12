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
    
    private lazy var readMoreButton: UIButton = {
        let shimmer = ShimmerButton()
        shimmer.setTitle("Continue reading", for: .normal)
        shimmer.gradientTint = .darkGray
        shimmer.gradientHighlight = .lightGray
        shimmer.sizeToFit()
        return shimmer
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
        setupUI()
    }
    
    // MARK: - Configurational Methods
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .black
    }
    
    private func  setupUI() {
        view.addSubview(articleCollectionView)
        view.addSubview(readMoreButton)
        
        articleCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(readMoreButton.snp.top)
        }
        readMoreButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            make.width.equalTo(200)
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
