//
//  CustomImageView.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation
import UIKit

class CustomImageView: UIImageView {
    
    // MARK: - Properties

    private lazy var activityLoader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }()
    
    // MARK: - Initializers

    init() {
        super.init(image: nil)
        addSubview(activityLoader)
        activityLoader.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func addLoader() {
        DispatchQueue.main.async {
            self.activityLoader.startAnimating()
        }
    }
    
    func removeLoader() {
        DispatchQueue.main.async {
            self.activityLoader.stopAnimating()
            self.activityLoader.removeFromSuperview()
        }
    }
}
