//
//  QuranNotifyApp.swift
//  QuranNotify
//
//  Created by Jawwad Ahmed on 14/2/2025.
//

import SwiftUI
import UserNotifications

@main
struct QuranNotifyApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        
        // Create custom actions for notifications
        let readMoreAction = UNNotificationAction(
            identifier: "READ_MORE",
            title: "Read More",
            options: .foreground
        )
        
        // Create categories for both types
        let verseCategory = UNNotificationCategory(
            identifier: "VERSE_NOTIFICATION",
            actions: [readMoreAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        let hadeesCategory = UNNotificationCategory(
            identifier: "HADEES_NOTIFICATION",
            actions: [readMoreAction],
            intentIdentifiers: [],
            options: .customDismissAction
        )
        
        // Register both categories
        UNUserNotificationCenter.current().setNotificationCategories([verseCategory, hadeesCategory])
        
        // Remove the automatic authorization request
        // NotificationManager.shared.requestAuthorization()
        
        return true
    }
    
    // Handle notification taps
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        if response.actionIdentifier == "READ_MORE" || response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            if let dayOfYear = userInfo["dayOfYear"] as? Int {
                let type = userInfo["type"] as? String ?? "verse"
                
                DispatchQueue.main.async {
                    let navigationManager = NavigationManager.shared
                    
                    if type == "hadees" {
                        let hadees = AllHadeesViewModel().hadees.first(where: { $0.dayOfYear == dayOfYear })
                        navigationManager.selectedHadees = hadees
                        navigationManager.showHadeesDetail = true
                    } else {
                        let verse = AllVersesViewModel().verses.first(where: { $0.dayOfYear == dayOfYear })
                        navigationManager.selectedVerse = verse
                        navigationManager.showVerseDetail = true
                    }
                    
                    navigationManager.selectedTab = 0  // Switch to Today tab
                }
            }
        }
        
        completionHandler()
    }
    
    // Show notification when app is in foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound, .badge, .list])
    }
}
