//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import Combine
import Observation

protocol HomeViewModelProtocol {
    var networkService: StoriesNetworkServiceProtocol { get }
    var sectionArticlesViewModel: SectionModel? { get }
    var sections: [String] { get }
    
    func fetchStoriesSections()
    func fetchArticles(for section: String)
}

@Observable
class HomeViewModel: HomeViewModelProtocol, ObservableObject {
    // MARK: - Properies
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @ObservationIgnored var networkService: StoriesNetworkServiceProtocol
    var sectionListViewModel: SectionListModel? = nil
    var sectionArticlesViewModel: SectionModel? = nil
    var sections: [String] {
        sectionListViewModel?.results
            .filter { Constants.HomeViewController.Sections.sectionsList.contains($0.displayName) }
            .map(\.displayName) ?? []
    }
    
    // MARK: - Initializers
    
    init(networkService: StoriesNetworkService = StoriesNetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    func fetchStoriesSections() {
        do {
            try networkService.fetchSectionList()
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionListViewModel = value
                }
                .store(in: &cancellableSet)
        } catch {
            print(error)
        }
    }
    
    func fetchArticles(for section: String) {
        do {
            try networkService.fetchArticles(for: section)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionArticlesViewModel = value
                    print(self?.sectionArticlesViewModel)
                }
                .store(in: &cancellableSet)
        } catch  {
            print(error)
        }
    }
}
