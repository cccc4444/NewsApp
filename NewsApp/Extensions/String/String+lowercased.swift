//
//  String+lowercased.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 05.07.2023.
//

import Foundation

extension String {
    func lowercasingFirstLetter() -> String {
      return prefix(1).lowercased() + dropFirst()
    }
    
    var withLowercasedFirstLetter: Self {
        lowercasingFirstLetter()
    }
}
