//
//  VDetailViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import UIKit

protocol VDetailViewControllerProtocol: AnyObject {
    func setupUIElements()
    func setupNavigationBarAppearance()
    func setupUI()
}

class VDetailViewController: UIViewController {
    // MARK: - Properties
    var presenter: DetailPresenterProtocol?
    
    // MARK: - UIElements
    private lazy var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.backgroundColor = .systemGray6
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemGray6
        return contentView
    }()
    
    private lazy var publishedDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .blackWhite
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
        label.textColor = .blackWhite
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
        label.textColor = .blackWhite
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var readMoreButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
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
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewDidLoad()
    }
}

extension VDetailViewController {
    @objc
    private func readMoreTapped() {
        presenter?.navigateToArticle()
    }
    
    @objc
    private func shareTapped() {
        presenter?.navigateToShareScreen()
    }
    
    @objc
    private func likeTapped() {
        presenter?.perforActionForArticle()
        updateBarButtonImage()
    }
}

extension VDetailViewController: VDetailViewControllerProtocol {
    func setupUIElements() {
        publishedDate.text = presenter?.publishedDate
        authors.text = presenter?.authors
        articleTitle.text = presenter?.articleTitle
        articleDescription.text = presenter?.articleDescription
        setupImage()
    }
    
    func setupNavigationBarAppearance() {
        let navBar = navigationController?.navigationBar
        let share = UIBarButtonItem(image: UIImage(systemNamed: .share), style: .plain, target: self, action: #selector(shareTapped))
        let like = UIBarButtonItem(image: presenter?.articleLikedState.image,
                                   style: .plain,
                                   target: self,
                                   action: #selector(likeTapped))
        navigationItem.rightBarButtonItems = [like, share]
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navBar?.tintColor = .blackWhite
    }
    
    private func setupImage() {
        switch presenter?.selectedSectionType {
        case .top:
            image.asyncLoadImage(urlSting: presenter?.largeMediaURL)
        case .general:
            image.asyncLoadImage(urlSting: presenter?.mediaURL)
        case nil:
            return
        }
    }
    
    private func updateBarButtonImage() {
        navigationItem.rightBarButtonItems?.first?.image = presenter?.articleLikedState.image
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(readMoreButtonView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        readMoreButtonView.addSubview(readMoreButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.width.equalTo(scrollView)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
        }
        
        articleTitle.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
        }
        
        readMoreButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom).offset(-20)
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
