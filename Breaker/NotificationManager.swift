//
//
//  Created by Ben Gauger on 4/1/23.
//

import Foundation
import UserNotifications
import UIKit

class NotificationHandler {
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        var trigger: UNNotificationTrigger?
        
        
        if type == "date" {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        }else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: true)
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
