//
//  ViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.fetchStoriesSections()
        bindSectionsViewModel()
    }
    
    private func bindSectionsViewModel() {
        viewModel.sectionListViewModel.bind { _ in
            
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
}

