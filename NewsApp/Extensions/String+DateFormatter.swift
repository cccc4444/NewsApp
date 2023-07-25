//
//  String+DateFormatter.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 25.07.2023.
//

import Foundation

extension String {
    var formatted: Self {
        Self(self.prefix(10)).beautified
    }
    
    var beautified: Self {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMMM d"
            return outputDateFormatter.string(from: date)
        }
        return self
    }
}
