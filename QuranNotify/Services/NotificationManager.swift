import UserNotifications
import SwiftUI

class NotificationManager {
    static let shared = NotificationManager()
    private let verses: [QuranVerse]
    private let hadees: [Hadees]
    
    private init() {
        self.verses = AllVersesViewModel().verses
        self.hadees = AllHadeesViewModel().hadees
        // Print current notification settings when manager is initialized
        checkNotificationStatus()
        setupNotificationCategories()
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification Settings:")
            print("Authorization Status: \(settings.authorizationStatus.rawValue)")
            print("Alert Setting: \(settings.alertSetting.rawValue)")
            print("Sound Setting: \(settings.soundSetting.rawValue)")
            print("Badge Setting: \(settings.badgeSetting.rawValue)")
        }
    }
    
    private func setupNotificationCategories() {
        // Create custom actions for both Quran and Hadees notifications
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
            options: [.customDismissAction]
        )
        
        let hadeesCategory = UNNotificationCategory(
            identifier: "HADEES_NOTIFICATION",
            actions: [readMoreAction],
            intentIdentifiers: [],
            options: [.customDismissAction]
        )
        
        // Register both categories
        UNUserNotificationCenter.current().setNotificationCategories([verseCategory, hadeesCategory])
    }
    
    func requestAuthorization() {
        print("Requesting notification authorization...")
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("✅ Notification permission granted")
                    self.scheduleTestNotification() // Schedule test notification immediately
                } else {
                    print("❌ Notification permission denied")
                    if let error = error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func scheduleNotifications(at time: Date) {
        print("Scheduling notification for time: \(time)")
        // Schedule both daily and immediate test notifications
        scheduleTestNotification()
        scheduleDailyNotification(at: time)
    }
    
    private func scheduleDailyNotification(at time: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        print("Current day of year: \(currentDayOfYear)")
        
        if let todayVerse = verses.first(where: { $0.dayOfYear == currentDayOfYear }) {
            let content = UNMutableNotificationContent()
            content.title = "Today's Quranic Verse"
            content.subtitle = todayVerse.arabicText
            content.body = todayVerse.translation
            content.sound = .default
            content.badge = 1
            content.categoryIdentifier = "VERSE_NOTIFICATION"
            content.threadIdentifier = "quran_notify"
            
            // Add app icon to notification
            if let iconAttachment = createNotificationAttachment() {
                content.attachments = [iconAttachment]
            }
            
            content.userInfo = [
                "dayOfYear": currentDayOfYear,
                "explanation": todayVerse.explanation
            ]
            
            var triggerComponents = DateComponents()
            triggerComponents.hour = components.hour
            triggerComponents.minute = components.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "dailyVerse",
                content: content,
                trigger: trigger
            )
            
            print("Scheduling daily notification for \(triggerComponents.hour ?? 0):\(triggerComponents.minute ?? 0)")
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling daily notification: \(error.localizedDescription)")
                } else {
                    print("✅ Daily notification scheduled successfully")
                }
            }
        }
    }
    
    func scheduleTestNotification() {
        print("Scheduling immediate test notification...")
        
        let calendar = Calendar.current
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        
        if let todayVerse = verses.first(where: { $0.dayOfYear == currentDayOfYear }) {
            let content = UNMutableNotificationContent()
            content.title = "Today's Quranic Verse"
            content.subtitle = todayVerse.arabicText
            content.body = todayVerse.translation
            content.sound = .defaultCritical
            content.badge = 1
            content.categoryIdentifier = "VERSE_NOTIFICATION"
            content.threadIdentifier = "quran_notify"
            
            // Add app icon to notification
            if let iconAttachment = createNotificationAttachment() {
                content.attachments = [iconAttachment]
            }
            
            // Store the day of year in userInfo for handling taps
            content.userInfo = [
                "dayOfYear": currentDayOfYear,
                "explanation": todayVerse.explanation
            ]
            
            // Make notification persistent
            content.interruptionLevel = .timeSensitive
            
            // Trigger after 5 seconds
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "verse_\(currentDayOfYear)",  // Unique identifier for each day
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("✅ Test notification scheduled successfully")
                }
            }
        }
    }
    
    // Helper function to create notification attachment from app icon
    private func createNotificationAttachment() -> UNNotificationAttachment? {
        guard let url = Bundle.main.url(forResource: "AppIcon", withExtension: "png") else {
            print("Error: Could not find app icon")
            return nil
        }
        
        do {
            let attachment = try UNNotificationAttachment(
                identifier: "appIcon",
                url: url,
                options: [
                    UNNotificationAttachmentOptionsTypeHintKey: "AAPLAppIconTypeHint",
                    UNNotificationAttachmentOptionsThumbnailHiddenKey: false,
                    UNNotificationAttachmentOptionsThumbnailClippingRectKey: CGRect(x: 0, y: 0, width: 1, height: 1).dictionaryRepresentation
                ]
            )
            return attachment
        } catch {
            print("Error creating notification attachment: \(error)")
            return nil
        }
    }
    
    private func listPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("\nPending Notifications (\(requests.count)):")
            for request in requests {
                print("- ID: \(request.identifier)")
                print("  Title: \(request.content.title)")
                print("  Trigger: \(String(describing: request.trigger))")
            }
        }
    }
    
    func cancelNotifications() {
        print("Cancelling all notifications")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    func scheduleHadeesNotifications(at time: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)
        
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        
        if let todayHadees = hadees.first(where: { $0.dayOfYear == currentDayOfYear }) {
            let content = UNMutableNotificationContent()
            content.title = "Today's Hadees"
            content.subtitle = todayHadees.narratedBy
            content.body = todayHadees.translation
            content.sound = .default
            content.badge = 1
            content.categoryIdentifier = "HADEES_NOTIFICATION"
            content.threadIdentifier = "hadees_notify"
            
            // Add app icon to notification
            if let iconAttachment = createNotificationAttachment() {
                content.attachments = [iconAttachment]
            }
            
            content.userInfo = [
                "dayOfYear": currentDayOfYear,
                "explanation": todayHadees.explanation,
                "type": "hadees"  // To differentiate between Quran and Hadees notifications
            ]
            
            var triggerComponents = DateComponents()
            triggerComponents.hour = components.hour
            triggerComponents.minute = components.minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "dailyHadees",
                content: content,
                trigger: trigger
            )
            
            print("Scheduling daily Hadees notification for \(triggerComponents.hour ?? 0):\(triggerComponents.minute ?? 0)")
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling Hadees notification: \(error.localizedDescription)")
                } else {
                    print("✅ Daily Hadees notification scheduled successfully")
                }
            }
        }
    }
    
    func scheduleTestHadeesNotification() {
        print("Scheduling immediate test Hadees notification...")
        
        let calendar = Calendar.current
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        
        if let todayHadees = hadees.first(where: { $0.dayOfYear == currentDayOfYear }) {
            let content = UNMutableNotificationContent()
            content.title = "Today's Hadees"
            content.subtitle = todayHadees.narratedBy
            content.body = todayHadees.translation
            content.sound = .defaultCritical
            content.badge = 1
            content.categoryIdentifier = "HADEES_NOTIFICATION"
            content.threadIdentifier = "hadees_notify"
            
            // Add app icon to notification
            if let iconAttachment = createNotificationAttachment() {
                content.attachments = [iconAttachment]
            }
            
            content.userInfo = [
                "dayOfYear": currentDayOfYear,
                "explanation": todayHadees.explanation,
                "type": "hadees"
            ]
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(
                identifier: "hadees_test",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("❌ Error scheduling test Hadees notification: \(error.localizedDescription)")
                } else {
                    print("✅ Test Hadees notification scheduled successfully")
                }
            }
        }
    }
    
    func cancelHadeesNotifications() {
        print("Cancelling all Hadees notifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let hadeesRequests = requests.filter { $0.content.threadIdentifier == "hadees_notify" }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: hadeesRequests.map { $0.identifier })
        }
    }
} 