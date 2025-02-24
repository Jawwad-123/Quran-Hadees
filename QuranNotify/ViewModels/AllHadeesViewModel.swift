import SwiftUI

class AllHadeesViewModel: ObservableObject {
    @Published var hadees: [Hadees] = []
    @Published var searchText: String = ""
    
    init() {
        hadees = generateYearOfHadees()
    }
    
    private func generateYearOfHadees() -> [Hadees] {
        var allHadees: [Hadees] = []
        
        // Base hadees that we'll use throughout the year
        let baseHadees = [
            (
                narratedBy: "Abu Hurairah",
                arabicText: "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ",
                translation: "Actions are judged by intentions",
                explanation: "This hadith emphasizes the importance of intention in Islam. Every action is judged based on the intention behind it.",
                source: "Sahih Bukhari",
                bookReference: "Book 1, Hadith 1"
            ),
            (
                narratedBy: "Abdullah ibn Umar",
                arabicText: "الدِّينُ النَّصِيحَةُ",
                translation: "The religion is sincerity",
                explanation: "This hadith teaches that sincere advice and well-wishing are fundamental to Islamic practice.",
                source: "Sahih Muslim",
                bookReference: "Book 1, Hadith 43"
            ),
            // Add more base hadees here...
        ]
        
        // Generate 365 hadees
        for dayOfYear in 1...365 {
            let baseIndex = (dayOfYear - 1) % baseHadees.count
            let baseHadees = baseHadees[baseIndex]
            
            let hadees = Hadees(
                dayOfYear: dayOfYear,
                narratedBy: baseHadees.narratedBy,
                arabicText: baseHadees.arabicText,
                translation: baseHadees.translation,
                explanation: "Day \(dayOfYear): \(baseHadees.explanation)",
                source: baseHadees.source,
                bookReference: baseHadees.bookReference
            )
            
            allHadees.append(hadees)
        }
        
        return allHadees
    }
    
    func getTodayHadees() -> Hadees? {
        let calendar = Calendar.current
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return hadees.first(where: { $0.dayOfYear == currentDayOfYear })
    }
} 