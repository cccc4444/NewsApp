//
//  LikedArticlesViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import UIKit

class LikedArticlesViewController: UIViewController {
    
    private var viewModel: LikedArticlesViewModelProtocol

    init(viewModel: LikedArticlesViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.controller = self
        self.view.backgroundColor = .white
        print(viewModel.getLikedArticles())
    }
}
