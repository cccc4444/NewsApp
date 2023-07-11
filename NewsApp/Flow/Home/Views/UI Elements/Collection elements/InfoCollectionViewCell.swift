//
//  InfoCollectionViewCell.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 11.07.2023.
//

import UIKit
import SnapKit

class InfoCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Elements
    private lazy var publishedDate: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var authors: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setup(data: DisplayableArticle) {
        self.publishedDate.text = data.publishedDate
        self.authors.text = data.byline
    }
    
    // MARK: - Configurational methods
    private func setupViews() {
        contentView.addSubview(publishedDate)
        contentView.addSubview(authors)
        
        publishedDate.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        authors.snp.makeConstraints { make in
            make.top.equalTo(publishedDate.snp.bottom).offset(10)
            make.leading.trailing.equalTo(publishedDate)
        }
    }
}
