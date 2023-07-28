//
//  MockManagedObject.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import CoreData
@testable import NewsApp

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
