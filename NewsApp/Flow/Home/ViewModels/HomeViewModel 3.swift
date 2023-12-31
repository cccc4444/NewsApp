//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import Combine
import Observation
import SwiftUI

protocol HomeViewModelProtocol {
    var controller: HomeViewContollerProtocol? { get set }
    var networkService: StoriesNetworkServiceProtocol { get }
    
    var sectionsPublisher: Published<[SectionModel]?>.Publisher { get }
    var mostViewedStoriesPublisher: Published<[MostViewedArticleModel]?>.Publisher { get }
    var sections: [String] { get }
    var mostViewdStoriesCount: Int { get }
}

protocol HomeViewModelNetworkingProtocol {
    func fetchStoriesSections()
    func fetchStories(for section: String)
    func fetchMostViewedStories(isRefresh: Bool)
    func getArticle(for indexPath: IndexPath) -> MostViewedArticleModel
}

extension HomeViewModelNetworkingProtocol {
    func fetchMostViewedStories(isRefresh: Bool = false) {
        fetchMostViewedStories(isRefresh: isRefresh)
    }
}

class HomeViewModel: HomeViewModelProtocol, HomeViewModelNetworkingProtocol, ObservableObject {
    
    // MARK: - Properies
    
    enum SectionType {
        case top
        case general
    }
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var networkService: StoriesNetworkServiceProtocol
    weak var controller: HomeViewContollerProtocol?
    
    @Published var sectionViewModel: [SectionModel]?
    var sectionsPublisher: Published<[SectionModel]?>.Publisher { $sectionViewModel }
    var sections: [String] {
        sectionViewModel?
            .filter { Constants.HomeViewController.Sections.sectionsList.contains($0.displayName) }
            .map(\.displayName) ?? []
    }
    
    @Published var mostViewedStoriesViewModel: [MostViewedArticleModel]?
    var mostViewedStoriesPublisher: Published<[MostViewedArticleModel]?>.Publisher { $mostViewedStoriesViewModel }
    var mostViewdStoriesCount: Int {
        mostViewedStoriesViewModel?.count ?? .zero
    }
    
    var sectionStoriesViewModel: [ArticleModel]?
    
    // MARK: - Initializers
    
    init(networkService: StoriesNetworkService = StoriesNetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Methods
    
    func getArticle(for indexPath: IndexPath) -> MostViewedArticleModel {
        mostViewedStoriesViewModel?[safe: indexPath.row] ?? .empty
    }
    
    // MARK: - Networking Methods
    
    func fetchStoriesSections() {
        do {
            try networkService.fetchSectionList()
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionViewModel = value.results
                }
                .store(in: &cancellableSet)
        } catch {
            print(error)
        }
    }
    
    func fetchStories(for section: String) {
        do {
            try networkService.fetchStories(for: section)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionStoriesViewModel = value.results
                }
                .store(in: &cancellableSet)
        } catch  {
        }
    }
    
    func fetchMostViewedStories(isRefresh: Bool) {
        do {
            try networkService.fetchMostViewedStories(days: 1)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.mostViewedStoriesViewModel = value.results
                    if isRefresh {
                        self?.controller?.endRefreshing()
                    }
                }
                .store(in: &cancellableSet)
        } catch {
            print(error)
        }
    }
}
