//
//  LikedArticleTableViewCell.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 17.07.2023.
//

import UIKit

class LikedArticleTableViewCell: UITableViewCell {
    // MARK: - UI Components
    
    private lazy var containerView: UIView = {
        return UIView()
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = false
        return label
    }()
    
    private lazy var author: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = false
        label.numberOfLines = .zero
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isUserInteractionEnabled = true
        selectionStyle = .none
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Mehods
    
    func setup(model: LikedArticleModel?) {
        guard let model else { return }
        title.text = model.title
        author.text = model.author
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(author)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.height.equalTo(70)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.trailing.equalToSuperview()
        }
        
        author.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.bottom.equalToSuperview()
        }
    }
}
