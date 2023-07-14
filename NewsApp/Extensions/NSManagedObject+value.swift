//
//  NSManagedObject+value.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 13.07.2023.
//

import Foundation
import CoreData

extension NSManagedObject {
    func value(forKey key: ManagedValueType) -> String? {
        value(forKey: key.value) as? String
    }
    
    func setValue(_ value: Any?, forKey key: ManagedValueType) {
        setValue(value, forKey: key.value)
    }
}
