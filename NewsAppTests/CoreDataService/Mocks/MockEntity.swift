//
//  MockEntity.swift
//  NewsAppTests
//
//  Created by Danylo Kushlianskyi on 28.07.2023.
//

import Foundation
import UIKit
import CoreData
@testable import NewsApp

class MockEntity: NSEntityDescription {
    static var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static func entity() -> NSEntityDescription {
        return .entity(
            forEntityName: Constants.CoreData.entityName,
            in: context)!
    }
}
