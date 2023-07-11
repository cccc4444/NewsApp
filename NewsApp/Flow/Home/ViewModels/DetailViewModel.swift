//
//  DetailViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 10.07.2023.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol {
    var article: DisplayableArticle { get }
    var numberOfSections: Int { get }
    var numberOfItemsInSections: Int { get }
    var selectedSectionType: HomeViewModel.SectionType? { get }
}

class DetailViewModel: DetailViewModelProtocol {
    // MARK: - Properties
    weak var homeViewModel: (HomeViewModelProtocol & HomeViewModelNetworkingProtocol)?
    var article: DisplayableArticle
    var numberOfSections: Int = 2
    var numberOfItemsInSections: Int = 1
    var selectedSectionType: HomeViewModel.SectionType? {
        homeViewModel?.selectedSectionType
    }
    
    // MARK: - Initializers
    init(homeViewModel: (HomeViewModelProtocol & HomeViewModelNetworkingProtocol)? = nil, article: DisplayableArticle) {
        self.homeViewModel = homeViewModel
        self.article = article
    }
}
