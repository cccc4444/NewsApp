//
//  LocalNotification.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 19.07.2023.
//

import Foundation
import UIKit

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        let categoryIdentifier = Constants.LocalNotifications.categoryIdentifier
        
        content.title = Constants.LocalNotifications.title
        content.body = Constants.LocalNotifications.body
        content.sound = UNNotificationSound.default
        content.badge = Constants.LocalNotifications.badge
        content.categoryIdentifier = categoryIdentifier
        
        var dateComponents = DateComponents()
        dateComponents.hour = Constants.LocalNotifications.hour
        dateComponents.minute = Constants.LocalNotifications.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: categoryIdentifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error {
                print(error.localizedDescription)
            }
        }
        
        let deleteAction = UNNotificationAction(identifier: Constants.LocalNotifications.deleteAction, title: Constants.LocalNotifications.deleteActionTitle, options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }
}
