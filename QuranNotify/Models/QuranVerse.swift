import Foundation

struct QuranVerse: Identifiable, Codable {
    let id: UUID
    let verseNumber: Int
    let chapterNumber: Int  // Surah number
    let chapterName: String // Surah name
    let verseNumberInChapter: Int
    let arabicText: String
    let translation: String
    let explanation: String
    let dayOfYear: Int
    
    init(id: UUID = UUID(), 
         verseNumber: Int,
         chapterNumber: Int,
         chapterName: String,
         verseNumberInChapter: Int,
         arabicText: String,
         translation: String,
         explanation: String,
         dayOfYear: Int) {
        self.id = id
        self.verseNumber = verseNumber
        self.chapterNumber = chapterNumber
        self.chapterName = chapterName
        self.verseNumberInChapter = verseNumberInChapter
        self.arabicText = arabicText
        self.translation = translation
        self.explanation = explanation
        self.dayOfYear = dayOfYear
    }
} 