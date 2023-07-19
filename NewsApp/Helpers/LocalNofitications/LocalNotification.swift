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
        let categoryIdentifier = "dailyNotification"
        
        content.title = "Hey"
        content.body = "Check out the latest stories"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = categoryIdentifier
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: categoryIdentifier, content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
            if let error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [snoozeAction, deleteAction],
                                              intentIdentifiers: [],
                                              options: [])
        notificationCenter.setNotificationCategories([category])
    }
}
