import Foundation

struct Hadees: Identifiable {
    let id = UUID()
    let dayOfYear: Int
    let narratedBy: String
    let arabicText: String
    let translation: String
    let explanation: String
    let source: String // e.g., "Sahih Bukhari", "Sahih Muslim", etc.
    let bookReference: String // e.g., "Book 1, Hadith 1"
} 