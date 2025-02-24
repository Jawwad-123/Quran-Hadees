import SwiftUI

class DailyVerseViewModel: ObservableObject {
    @Published var todayVerse: QuranVerse?
    @Published var showFullExplanation = false
    private let allVerses = AllVersesViewModel()
    
    init() {
        updateTodayVerse()
    }
    
    func updateTodayVerse() {
        todayVerse = allVerses.getTodayVerse()
    }
} 