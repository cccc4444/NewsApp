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
    var sectionStoriesViewModelPublisher: Published<[ArticleModel]?>.Publisher { get }
    
    var sections: [HomeViewModel.SectionType] { get }
    var storiesCount: Int { get }
    
    func refreshStories()
    func sectionChosen(sectionName: String, isGeneralSection: Bool)
}

protocol HomeViewModelNetworkingProtocol {
    func fetchStoriesSections()
    func fetchStories(for section: String, isRefresh: Bool)
    func fetchMostViewedStories(isRefresh: Bool)
    func getArticle(for indexPath: IndexPath) -> DisplayableArticle?
}

extension HomeViewModelNetworkingProtocol {
    func fetchMostViewedStories(isRefresh: Bool = false) {
        fetchMostViewedStories(isRefresh: isRefresh)
    }
    func fetchStories(for section: String, isRefresh: Bool = false) {
        fetchStories(for: section, isRefresh: isRefresh)
    }
}

class HomeViewModel: HomeViewModelProtocol, HomeViewModelNetworkingProtocol, ObservableObject {
    enum SectionType {
        case top(name: String = Constants.HomeViewController.defaultSectionName)
        case general(sectionNames: [String])
    }
    
    // MARK: - Properies
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var networkService: StoriesNetworkServiceProtocol
    weak var controller: HomeViewContollerProtocol?
    
    private var isGeneralSectionType: Bool?
    private var selectedSection: String
    private var shouldRefreshGeneralStories: Bool {
        return isGeneralSectionType ?? false
    }
    
    @Published var sectionViewModel: [SectionModel]?
    var sectionsPublisher: Published<[SectionModel]?>.Publisher { $sectionViewModel }
    @Published var mostViewedStoriesViewModel: [MostViewedArticleModel]?
    var mostViewedStoriesPublisher: Published<[MostViewedArticleModel]?>.Publisher { $mostViewedStoriesViewModel }
    @Published var sectionStoriesViewModel: [ArticleModel]?
    var sectionStoriesViewModelPublisher: Published<[ArticleModel]?>.Publisher { $sectionStoriesViewModel }
    
    var sections: [SectionType] {
        let filteredSections = sectionViewModel?
            .filter { Constants.HomeViewController.Sections.sectionsList.contains($0.displayName) }
            .map(\.displayName) ?? []
        return [.top()] + [.general(sectionNames: filteredSections)]
    }
    var storiesCount: Int {
        guard let isGeneralType = isGeneralSectionType, isGeneralType else {
            return mostViewedStoriesViewModel?.count ?? .zero
        }
        return sectionStoriesViewModel?.count ?? .zero
    }
    
    // MARK: - Initializers
    
    init(networkService: StoriesNetworkService = StoriesNetworkService()) {
        self.networkService = networkService
        self.selectedSection = Constants.HomeViewController.defaultSectionName
    }
    
    // MARK: - Methods
    
    func sectionChosen(sectionName: String, isGeneralSection: Bool) {
        selectedSection = sectionName
        isGeneralSectionType = isGeneralSection
        guard isGeneralSection else {
            fetchMostViewedStories()
            return
        }
        fetchStories(for: sectionName.withLowercasedFirstLetter)
    }
    
    func refreshStories() {
        guard shouldRefreshGeneralStories else {
            fetchMostViewedStories(isRefresh: true)
            return
        }
        fetchStories(for: selectedSection, isRefresh: true)
    }
    
    func getArticle(for indexPath: IndexPath) -> DisplayableArticle? {
        guard let isGeneralType = isGeneralSectionType, isGeneralType else {
            return mostViewedStoriesViewModel?[safe: indexPath.row]
        }
        return sectionStoriesViewModel?[safe: indexPath.row]
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
    
    func fetchStories(for section: String, isRefresh: Bool) {
        do {
            try networkService.fetchStories(for: section)
                .receive(on: DispatchQueue.main)
                .sink { error in
                    if case .failure = error {
                        print(error)
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionStoriesViewModel = value.results
                    if isRefresh {
                        self?.controller?.endRefreshing()
                    }
                }
                .store(in: &cancellableSet)
        } catch  {
            print(error)
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
