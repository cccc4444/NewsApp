//
//  CoreDataService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation
import CoreData
import UIKit

class LikedArtickePersistentService {
    // MARK: - Properties
    static var shared: LikedArtickePersistentService {
        LikedArtickePersistentService()
    }
    
    // MARK: - Methods
    func saveArticle(with likedArticle: DisplayableArticle, completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.noAppDelegate))
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.CoreData.entityName, in: managedContext) else {
            return
        }
        
        let article = NSManagedObject(entity: entity, insertInto: managedContext)
        article.setValue(likedArticle.title, forKey: .title)
        article.setValue(likedArticle.byline, forKey: .author)
        article.setValue(likedArticle.url, forKey: .url)
        do {
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchArticles(completion: @escaping (Swift.Result<[NSManagedObject], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.noAppDelegate))
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.CoreData.entityName)
        do {
            let result = try managedContext.fetch(fetchRequest)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteAllArticles(completion: @escaping (Swift.Result<Bool, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(CoreDataError.noAppDelegate))
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.CoreData.entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}
