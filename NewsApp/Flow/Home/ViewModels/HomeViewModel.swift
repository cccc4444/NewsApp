//
//  HomeViewModel.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation
import Combine

protocol HomeViewModelProtocol: AnyObject {
    var controller: (AlertProtocol & HomeViewContollerProtocol)? { get set }
    var networkService: StoriesNetworkServiceProtocol { get }
    
    var sectionsPublisher: Published<[SectionModel]?>.Publisher { get }
    var mostViewedStoriesViewModel: [MostViewedArticleModel]? { get }
    var mostViewedStoriesPublisher: Published<[MostViewedArticleModel]?>.Publisher { get }
    var sectionStoriesViewModel: [ArticleModel]? { get }
    var sectionStoriesViewModelPublisher: Published<[ArticleModel]?>.Publisher { get }
    
    var selectedSectionType: HomeViewModel.SectionType { get set }
    var sections: [HomeViewModel.SectionType] { get }
    var storiesCount: Int { get }
    
    func refreshStories()
    func setSectionAction()
    func setSelectedSectionName(_ name: String)
}

protocol HomeViewPersistentProtocol: AnyObject {
    func likeArticle(at indexPath: IndexPath)
}

protocol HomeViewModelNetworkingProtocol: AnyObject {
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

class HomeViewModel: HomeViewModelProtocol, HomeViewModelNetworkingProtocol, HomeViewPersistentProtocol, ObservableObject {
    enum SectionType {
        case top(name: String = Constants.HomeViewController.defaultSectionName)
        case general(sectionNames: [String])
    }
    
    // MARK: - Properies
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    var networkService: StoriesNetworkServiceProtocol
    weak var controller: (AlertProtocol & HomeViewContollerProtocol)?
    
    var selectedSectionType: HomeViewModel.SectionType = HomeViewModel.SectionType.defaultValue
    private var selectedSectionName: String
    
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
        if case .general = selectedSectionType {
            return sectionStoriesViewModel?.count ?? .zero
        }
        return mostViewedStoriesViewModel?.count ?? .zero
    }
    
    // MARK: - Initializers
    
    init(networkService: StoriesNetworkService = StoriesNetworkService()) {
        self.networkService = networkService
        self.selectedSectionName = Constants.HomeViewController.defaultSectionName
    }
    
    // MARK: - Methods
    
    func getArticle(for indexPath: IndexPath) -> DisplayableArticle? {
        if case .general = selectedSectionType {
            return sectionStoriesViewModel?[safe: indexPath.row]
        }
        return mostViewedStoriesViewModel?[safe: indexPath.row]
    }
    
    func setSectionAction() {
        if case .general = selectedSectionType {
            fetchStories(for: selectedSectionName.withLowercasedFirstLetter)
            return
        }
        fetchMostViewedStories()
    }
    
    func setSelectedSectionName(_ name: String) {
        selectedSectionName = name
    }
    
    func refreshStories() {
        fetchMostViewedStories(isRefresh: true)
        fetchStories(for: selectedSectionName, isRefresh: true)
    }
    
    // MARK: - Persistent methods
    func likeArticle(at indexPath: IndexPath) {
        guard let article = getArticle(for: indexPath) else { return }
        LikedArticlePersistentService.shared.isArticleSaved(with: article) { [weak self] result in
            switch result {
            case .success(let isSaved):
                if isSaved {
                    self?.controller?.showLikeWarning()
                    return
                }
                self?.saveLikedArticle(article: article)
            case .failure(let error):
                self?.controller?.present(alert: .coreDataCheckingForPresenceIssue(message: error.localizedDescription))
            }
        }
    }
    
    private func saveLikedArticle(article: DisplayableArticle) {
        LikedArticlePersistentService.shared.saveArticle(with: article) { [weak self] result in
            if case let .failure(error) = result {
                self?.controller?.present(alert: .coreDataSavingIssue(message: error.localizedDescription))
            }
        }
    }
    
    // MARK: - Networking Methods
    
    func fetchStoriesSections() {
        do {
            try networkService.fetchSectionList()
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    if case let .failure(error as HTTPErrorResponse) = error {
                        self?.controller?.present(alert: .rateLimit(message: error.fault.faultString))
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionViewModel = value.results
                }
                .store(in: &cancellableSet)
        } catch {
            controller?.present(alert: .badServerResponse)
        }
    }
    
    func fetchStories(for section: String, isRefresh: Bool) {
        do {
            try networkService.fetchStories(for: section)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    if case let .failure(error as HTTPErrorResponse) = error {
                        self?.controller?.present(alert: .rateLimit(message: error.fault.faultString))
                        self?.controller?.endRefreshing()
                    }
                } receiveValue: { [weak self] value in
                    self?.sectionStoriesViewModel = value.results.filter {
                        $0.title.isNotEmpty
                    }
                    if isRefresh {
                        self?.controller?.endRefreshing()
                    }
                }
                .store(in: &cancellableSet)
        } catch {
            controller?.present(alert: .badServerResponse)
        }
    }
    
    func fetchMostViewedStories(isRefresh: Bool) {
        do {
            try networkService.fetchMostViewedStories(days: 1)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] error in
                    if case let .failure(error as HTTPErrorResponse) = error {
                        self?.controller?.present(alert: .rateLimit(message: error.fault.faultString))
                        self?.controller?.endRefreshing()
                    }
                } receiveValue: { [weak self] value in
                    self?.mostViewedStoriesViewModel = value.results.filter {
                        $0.title.isNotEmpty
                    }
                    if isRefresh {
                        self?.controller?.endRefreshing()
                    }
                }
                .store(in: &cancellableSet)
        } catch {
            controller?.present(alert: .badServerResponse)
        }
    }
}

fileprivate extension HomeViewModel.SectionType {
    static var defaultValue: Self {
        return .top(name: "")
    }
}
