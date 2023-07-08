//
//  AlertProtocol.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 08.07.2023.
//

import Foundation
import UIKit

protocol AlertProtocol: AnyObject {
    func present(alert type: AlertType)
}

enum AlertType {
    case badServerResponse
    case rateLimit(message: String)
}

extension AlertType {
    var title: String {
        switch self {
        case .rateLimit:
            "Could not fetch news"
        case .badServerResponse:
            "Something went wrong"
        }
    }
    
    var message: String {
        switch self {
        case .rateLimit(message: let message):
            "\(message)"
        case .badServerResponse:
            "Please try again later"
        }
    }
}

extension UIViewController: AlertProtocol {
    func present(alert type: AlertType) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    func presentAlertAction(ofType type: AlertType, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: type.title, message: type.message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
}

