//
//  MockLikedArticlePersistentService.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import CoreData
import UIKit
@testable import NewsApp

class MockLikedArticlePersistentService: LikedArticlePersistentProtocol {
    var articles: [NSManagedObject] = []
    var shouldFail: Bool = false

    func saveArticle(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.saveError))
            return
        }
        let mockManagedObject = MockManagedObject(article: likedArticle)
        articles.append(mockManagedObject)
        
        completion(.success(true))
    }

    func fetchArticles(completion: @escaping (Swift.Result<[NSManagedObject], Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.fetchError))
            return
        }
        completion(.success(articles))
    }

    func isArticleSaved(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.isSavedError))
            return
        }
        let isSaved = articles.contains {
            $0.value(forKey: .title) == likedArticle.title
        }
        completion(.success(isSaved))
    }

    func deleteArticle(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.deleteError))
            return
        }
        guard let index = articles.firstIndex(where: { $0.value(forKey: .title) == likedArticle.title }) else {
            completion(.success(false))
            return
        }

        articles.remove(at: index)
        completion(.success(true))
    }

    func deleteAllArticles(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        if shouldFail {
            completion(.failure(MockPersistentError.deleteAllError))
            return
        }
        articles.removeAll()
        completion(.success(true))
    }
}

class MockManagedObject: NSManagedObject {
    @NSManaged var title: String?
    @NSManaged var author: String?
    @NSManaged var url: String?
    @NSManaged var section: String?
    
    convenience init(article: DisplayableArticle) {
        self.init(
            entity: MockEntity.entity(),
            insertInto: MockEntity.context
        )
        self.title = article.title
        self.author = article.byline
        self.url = article.url
        self.section = article.section
    }
}

class MockEntity: NSEntityDescription {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static func entity() -> NSEntityDescription {
        return .entity(
            forEntityName: Constants.CoreData.entityName,
            in: context)!
    }
}

enum MockPersistentError: Error {
    case saveError
    case fetchError
    case isSavedError
    case deleteError
    case deleteAllError
}

struct MockDisplayableArticle: DisplayableArticle {
    var section: String
    var subsection: String
    var title: String
    var abstract: String
    var url: String
    var uri: String
    var byline: String
    var publishedDate: String
    var desFacet: [String]
    var orgFacet: [String]
    var perFacet: [String]
    var geoFacet: [String]
    var multimedia: [NewsApp.Multimedia]?
    
    init(section: String, subsection: String, title: String, abstract: String, url: String, uri: String, byline: String, publishedDate: String, desFacet: [String], orgFacet: [String], perFacet: [String], geoFacet: [String], multimedia: [Multimedia]? = nil) {
        self.section = section
        self.subsection = subsection
        self.title = title
        self.abstract = abstract
        self.url = url
        self.uri = uri
        self.byline = byline
        self.publishedDate = publishedDate
        self.desFacet = desFacet
        self.orgFacet = orgFacet
        self.perFacet = perFacet
        self.geoFacet = geoFacet
        self.multimedia = multimedia
    }
    
    static func createStubArticle(title: String) -> Self {
        return .init(section: "", subsection: "", title: title, abstract: "", url: "", uri: "", byline: "", publishedDate: "", desFacet: [], orgFacet: [], perFacet: [], geoFacet: [])
    }
}


