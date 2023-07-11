//
//  DetailCollectionViewCell.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 11.07.2023.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: .noImage)
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var articleDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
        label.numberOfLines = .zero
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(data: DisplayableArticle, articleType: HomeViewModel.SectionType?) {
        title.text = data.title
        articleDescription.text = data.abstract
        setupImage(data: data, articleType: articleType)
    }
    
    private func setupImage(data: DisplayableArticle, articleType: HomeViewModel.SectionType?) {
        switch articleType {
        case .top:
            image.asyncLoadImage(urlSting: data.largeMediaURL)
        case .general:
            image.asyncLoadImage(urlSting: data.mediaURL)
        case nil:
            return
        }
    }
    
    // MARK: - Congigurational methods
    private func setupViews() {
        contentView.addSubview(title)
        contentView.addSubview(image)
        contentView.addSubview(articleDescription)
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        articleDescription.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(20)
            make.leading.trailing.equalTo(title)
        }
    }
}
