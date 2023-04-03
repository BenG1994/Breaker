//
//  BreakerApp.swift
//  Breaker
//
//  Created by Ben Gauger on 4/1/23.
//

import SwiftUI
import UserNotifications

@main
struct BreakerApp: App {
    
    init() {
        requestAuthorization()
    }
    
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("error \(error.localizedDescription)")
            }else {
                print ("success")
            }
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
