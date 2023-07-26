//
//  DetailInteractor.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 26.07.2023.
//

import Foundation

protocol DetailInteractorProtocol: AnyObject {
    func deleteArticle(_ article: DisplayableArticle, completion: @escaping (_ error: String) -> Void)
    func saveArticle(_ article: DisplayableArticle, completion: @escaping (_ error: String) -> Void)
    func isArticleSaved(_ article: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void)
}

class DetailInteractor: DetailInteractorProtocol {
    func deleteArticle(_ article: DisplayableArticle, completion: @escaping (String) -> Void) {
        LikedArticlePersistentService.shared.deleteArticle(with: article) { result in
            if case let .failure(error) = result {
                completion(error.localizedDescription)
                return
            }
        }
    }
    
    func saveArticle(_ article: DisplayableArticle, completion: @escaping (String) -> Void) {
        LikedArticlePersistentService.shared.saveArticle(with: article) { result in
            if case let .failure(error) = result {
                completion(error.localizedDescription)
                return
            }
        }
    }
    
    func isArticleSaved(_ article: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        LikedArticlePersistentService.shared.isArticleSaved(with: article) { result in
            switch result {
            case .success(let isSaved):
                completion(.success(isSaved))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
