//
//  DetailViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 10.07.2023.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    // MARK: - Properies
    private var viewModel: DetailViewModelProtocol
    
    // MARK: - UIElements
    
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .white
        return contentView
    }()
    
    private lazy var publishedDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = .zero
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var authors: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = .zero
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var articleTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: .noImage)
        return view
    }()
    
    private lazy var articleDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var readMoreButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var readMoreButton: UIButton = {
        let shimmer = ShimmerButton()
        shimmer.setTitle("Continue reading", for: .normal)
        shimmer.gradientTint = .darkGray
        shimmer.gradientHighlight = .lightGray
        shimmer.sizeToFit()
        shimmer.addTarget(self, action: #selector(readMoreTapped), for: .touchUpInside)
        return shimmer
    }()
    
    private lazy var elementsArray = {
        [publishedDate, authors, articleTitle, image, articleDescription]
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: elementsArray)
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
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
        setupUIElements()
        setupNavigationBarAppearance()
        setupUI()
    }

    private func setupUIElements() {
        publishedDate.text = viewModel.article.publishedDate
        authors.text = viewModel.article.byline
        articleTitle.text = viewModel.article.title
        articleDescription.text = viewModel.article.abstract
        setupImage()
    }
    
    private func setupImage() {
        switch viewModel.selectedSectionType {
        case .top:
            image.asyncLoadImage(urlSting: viewModel.article.largeMediaURL)
        case .general:
            image.asyncLoadImage(urlSting: viewModel.article.mediaURL)
        case nil:
            return
        }
    }
    
    // MARK: - Actions
    @objc
    private func readMoreTapped() {
        guard let url = URL(string: viewModel.selectedArticleURL) else { return }
        present(SFSafariViewController(url: url), animated: true)
    }
    
    // MARK: - Configurational Methods
    private func setupNavigationBarAppearance() {
        let navBar = self.navigationController?.navigationBar
        navBar?.tintColor = .black
    }
    
    private func  setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        contentView.addSubview(readMoreButtonView)
        readMoreButtonView.addSubview(readMoreButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(readMoreButtonView.snp.top).offset(-10)
        }
        
        readMoreButtonView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(contentView)
            make.height.equalTo(50)
        }
        
        readMoreButton.snp.makeConstraints { make in
            make.edges.equalTo(readMoreButtonView)
        }
        
        publishedDate.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        image.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        stackView.setCustomSpacing(5, after: publishedDate)
        stackView.setCustomSpacing(10, after: authors)
        stackView.setCustomSpacing(10, after: articleTitle)
        stackView.setCustomSpacing(10, after: image)
    }
}
