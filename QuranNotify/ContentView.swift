//
//  ContentView.swift
//  QuranNotify
//
//  Created by Jawwad Ahmed on 14/2/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigationManager = NavigationManager.shared
    
    var body: some View {
        TabView(selection: $navigationManager.selectedTab) {
            DailyVerseView()
                .tabItem {
                    Label("Today", systemImage: "book.fill")
                }
                .tag(0)
            
            AllVersesView()
                .tabItem {
                    Label("All Verses", systemImage: "books.vertical.fill")
                }
                .tag(1)
            
            AllHadeesView()
                .tabItem {
                    Label("All Hadees", systemImage: "text.book.closed")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(3)
        }
        .sheet(isPresented: $navigationManager.showVerseDetail) {
            if let verse = navigationManager.selectedVerse {
                VerseDetailView(verse: verse)
            }
        }
        .sheet(isPresented: $navigationManager.showHadeesDetail) {
            if let hadees = navigationManager.selectedHadees {
                HadeesDetailView(hadees: hadees)
            }
        }
    }
}

// Navigation manager to handle deep linking and navigation
class NavigationManager: ObservableObject {
    @Published var selectedTab = 0
    @Published var showVerseDetail = false
    @Published var showHadeesDetail = false
    @Published var selectedVerse: QuranVerse?
    @Published var selectedHadees: Hadees?
    
    static let shared = NavigationManager()
}

#Preview {
    ContentView()
}
