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
    var sections: [String] { get }
    
    func fetchStoriesSections()
}

@Observable
class HomeViewModel: HomeViewModelProtocol, ObservableObject {
    // MARK: - Properies
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    @ObservationIgnored var networkService: StoriesNetworkServiceProtocol
    var sectionsViewModel: SectionListModel? = nil
    var sections: [String] {
        sectionsViewModel?.results.compactMap { $0.section } ?? .init()
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
                    self?.sectionsViewModel = value
                }
                .store(in: &cancellableSet)
        } catch {
            print(error)
        }
    }
}
