//
//  StoriesTableViewCell.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import UIKit
import SnapKit

class StoriesTableViewCell: UITableViewCell {
    // MARK: - UI Components
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        return view
    }()
    
    private lazy var coverImage: CustomImageView = {
        let view = CustomImageView()
        view.cornerRadius = 5
        view.image = UIImage(named: .noImage)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .blackWhite
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
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
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
    
    func setup(model: DisplayableArticle?) {
        guard let model else { return }
        title.text = model.title
        author.text = model.byline
        setupImage(url: model.mediaURL)
    }
    
    private func setupImage(url: String?) {
        guard let url else { return }
        coverImage.asyncLoadImage(urlSting: url)
    }
    
    private func setupViews() {
        contentView.backgroundColor = .systemGray6
        contentView.addSubview(containerView)
        containerView.addSubview(coverImage)
        containerView.addSubview(title)
        containerView.addSubview(author)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.height.equalTo(100)
        }
        
        coverImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
        
        title.snp.makeConstraints { make in
            make.leading.equalTo(coverImage.snp.trailing).offset(10)
            make.top.trailing.equalToSuperview()
        }
        
        author.snp.makeConstraints { make in
            make.leading.trailing.equalTo(title)
            make.bottom.equalToSuperview()
        }
    }
}
