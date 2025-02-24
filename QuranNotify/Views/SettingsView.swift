import SwiftUI
import UserNotifications

struct SettingsView: View {
    @State private var notificationTime = Date()
    @State private var hadeesNotificationTime = Date()
    @State private var notificationsEnabled = false
    @State private var hadeesNotificationsEnabled = false
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Quran Notifications") {
                    Toggle("Enable Daily Verse Notifications", isOn: $notificationsEnabled)
                    
                    if notificationsEnabled {
                        DatePicker(
                            "Notification Time",
                            selection: $notificationTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                
                Section("Hadees Notifications") {
                    Toggle("Enable Daily Hadees Notifications", isOn: $hadeesNotificationsEnabled)
                    
                    if hadeesNotificationsEnabled {
                        DatePicker(
                            "Notification Time",
                            selection: $hadeesNotificationTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                
                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .onAppear {
                // Only update from system settings if previously authorized
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    if settings.authorizationStatus != .notDetermined {
                        DispatchQueue.main.async {
                            notificationsEnabled = settings.authorizationStatus == .authorized
                            hadeesNotificationsEnabled = settings.authorizationStatus == .authorized
                        }
                    }
                }
            }
            .onChange(of: notificationTime) { _ in
                if notificationsEnabled {
                    NotificationManager.shared.scheduleNotifications(at: notificationTime)
                }
            }
            .onChange(of: notificationsEnabled) { isEnabled in
                if isEnabled {
                    NotificationManager.shared.requestAuthorization()
                    // Only schedule notifications after a slight delay to ensure authorization is complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationManager.shared.scheduleNotifications(at: notificationTime)
                    }
                } else {
                    NotificationManager.shared.cancelNotifications()
                }
            }
            .onChange(of: hadeesNotificationTime) { _ in
                if hadeesNotificationsEnabled {
                    NotificationManager.shared.scheduleHadeesNotifications(at: hadeesNotificationTime)
                }
            }
            .onChange(of: hadeesNotificationsEnabled) { isEnabled in
                if isEnabled {
                    NotificationManager.shared.requestAuthorization()
                    // Only schedule notifications after a slight delay to ensure authorization is complete
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        NotificationManager.shared.scheduleHadeesNotifications(at: hadeesNotificationTime)
                    }
                } else {
                    NotificationManager.shared.cancelHadeesNotifications()
                }
            }
            .alert("Notifications Disabled", isPresented: $showingPermissionAlert) {
                Button("Open Settings", role: .none) {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsURL)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable notifications in Settings to receive daily verses.")
            }
        }
    }
}

#Preview {
    SettingsView()
} 
