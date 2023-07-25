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
    case coreDataSavingIssue(message: String)
    case coreDataFetchingIssue(message: String)
    case coreDataDeletionIssue(message: String)
    case coreDataCheckingForPresenceIssue(message: String)
    case kCFethingIssue(message: String)
    case kCSavingIssue(message: String)
    case kCDeletingIssue(message: String)
    case kCCheckingForPresenceIssue(message: String)
}

extension AlertType {
    var title: String {
        switch self {
        case .rateLimit:
            "Could not fetch news"
        case .badServerResponse:
            "Something went wrong"
        case .coreDataSavingIssue:
            "Could not add to liked articles"
        case .coreDataFetchingIssue:
            "Could not fetch liked articles"
        case .coreDataDeletionIssue:
            "Could not delete liked article"
        case .coreDataCheckingForPresenceIssue:
            "Could not check article for presence"
        case .kCFethingIssue:
            "Could not fetch secret articles"
        case .kCSavingIssue:
            "Could not save secret article"
        case .kCDeletingIssue:
            "Could not delete a secret article"
        case .kCCheckingForPresenceIssue:
            "Could not check secret article for presence"
        }
    }
    
    var message: String {
        switch self {
        case .rateLimit(message: let message),
                .coreDataSavingIssue(let message),
                .coreDataFetchingIssue(let message),
                .coreDataDeletionIssue(let message),
                .coreDataCheckingForPresenceIssue(let message),
                .kCFethingIssue(let message),
                .kCSavingIssue(let message),
                .kCDeletingIssue(let message),
                .kCCheckingForPresenceIssue(let message):
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
