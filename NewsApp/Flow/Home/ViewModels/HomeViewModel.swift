//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import Combine

protocol HomeViewModelProtocol {
    var networkService: StoriesNetworkServiceProtocol { get }
    var sectionListViewModel: Observable<SectionListModel?> { get }
    
    func fetchStoriesSections()
}

class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Properies
    
    var networkService: StoriesNetworkServiceProtocol
    var sectionListViewModel: Observable<SectionListModel?> = Observable(nil)
    private var cancellableSet: Set<AnyCancellable> = []
    
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
                    self?.sectionListViewModel = Observable(value)
                }
                .store(in: &cancellableSet)
        } catch {
            print(error)
        }
    }
}
