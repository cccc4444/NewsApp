//
//  UITableViewCell+dequeueCell.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 06.07.2023.
//

import Foundation
import UIKit

extension UITableViewCell {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}

extension UICollectionViewCell {
    static var reuseID: String {
        return NSStringFromClass(self)
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>() -> T {
        return dequeueReusableCell(withIdentifier: T.reuseID) as? T ?? T()
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: T.reuseID, for: indexPath) as? T ?? T()
    }
}
