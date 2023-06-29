//
//  Int+isInBetween.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 29.06.2023.
//

import Foundation

extension Int {
    func isInBetween(of lower: Int, and higher: Int) -> Bool {
        lower < higher && (lower...higher).contains(self)
    }
}
