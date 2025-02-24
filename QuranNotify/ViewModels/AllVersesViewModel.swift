import SwiftUI

class AllVersesViewModel: ObservableObject {
    @Published var verses: [QuranVerse] = []
    @Published var searchText: String = ""
    
    init() {
        verses = generateYearOfVerses()
    }
    
    private func generateYearOfVerses() -> [QuranVerse] {
        var allVerses: [QuranVerse] = []
        
        // Base verses that we'll repeat throughout the year
        let baseVerses = [
            // Al-Fatiha (The Opening) - Chapter 1
            (
                chapterNumber: 1,
                chapterName: "Al-Fatiha",
                verseNumberInChapter: 1,
                arabicText: "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
                translation: "In the name of Allah, the Most Gracious, the Most Merciful",
                explanation: "This opening verse, known as the Bismillah, begins 113 of the 114 chapters of the Quran. It teaches us to start all actions by invoking Allah's name."
            ),
            // ... other base verses
        ]
        
        // Generate 365 verses by repeating and modifying the base verses
        for dayOfYear in 1...365 {
            let baseIndex = (dayOfYear - 1) % baseVerses.count
            let baseVerse = baseVerses[baseIndex]
            
            let verse = QuranVerse(
                verseNumber: dayOfYear,
                chapterNumber: baseVerse.chapterNumber,
                chapterName: baseVerse.chapterName,
                verseNumberInChapter: baseVerse.verseNumberInChapter,
                arabicText: baseVerse.arabicText,
                translation: baseVerse.translation,
                explanation: "Day \(dayOfYear): \(baseVerse.explanation)",
                dayOfYear: dayOfYear
            )
            
            allVerses.append(verse)
        }
        
        return allVerses
    }
    
    // Helper function to get today's verse
    func getTodayVerse() -> QuranVerse? {
        let calendar = Calendar.current
        let currentDayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return verses.first(where: { verse in
            verse.dayOfYear == currentDayOfYear
        })
    }
}

// Extension to store the base verses
private extension AllVersesViewModel {
    var baseVerses: [(chapterNumber: Int, chapterName: String, verseNumberInChapter: Int, arabicText: String, translation: String, explanation: String)] {
        return [
            // 1. Al-Fatiha 1:1 - The Opening
            (1, "Al-Fatiha", 1, 
             "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ", 
             "In the name of Allah, the Most Gracious, the Most Merciful",
             "The opening verse of the Quran, teaching us to begin all actions with Allah's name"),
            
            // 2. Al-Baqarah 2:255 - Ayatul Kursi
            (2, "Al-Baqarah", 255, 
             "اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ ۚ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ",
             "Allah - there is no deity except Him, the Ever-Living, the Self-Sustaining. Neither drowsiness overtakes Him nor sleep",
             "Known as Ayatul Kursi (The Throne Verse), one of the most powerful verses describing Allah's attributes"),
            
            // 3. Al-Imran 3:8 - Seeking Guidance
            (3, "Al-Imran", 8,
             "رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِن لَّدُنكَ رَحْمَةً ۚ إِنَّكَ أَنتَ الْوَهَّابُ",
             "Our Lord, let not our hearts deviate after You have guided us and grant us from Yourself mercy. Indeed, You are the Bestower",
             "A beautiful dua (supplication) teaching us to ask Allah for steadfastness in faith"),
            
            // 4. Al-Hashr 59:22 - Beautiful Names of Allah
            (59, "Al-Hashr", 22,
             "هُوَ اللَّهُ الَّذِي لَا إِلَٰهَ إِلَّا هُوَ ۖ عَالِمُ الْغَيْبِ وَالشَّهَادَةِ ۖ هُوَ الرَّحْمَٰنُ الرَّحِيمُ",
             "He is Allah, other than whom there is no deity, Knower of the unseen and the witnessed. He is the Most Gracious, the Most Merciful",
             "This verse mentions some of Allah's beautiful names and attributes"),
            
            // 5. Al-Ikhlas 112:1-2 - Pure Monotheism
            (112, "Al-Ikhlas", 1,
             "قُلْ هُوَ اللَّهُ أَحَدٌ ﴿١﴾ اللَّهُ الصَّمَدُ",
             "Say, 'He is Allah, [who is] One, Allah, the Eternal Refuge'",
             "These verses from Surah Al-Ikhlas define the pure Islamic monotheism"),
            
            // 6. Al-Furqan 25:63 - Character of Believers
            (25, "Al-Furqan", 63,
             "وَعِبَادُ الرَّحْمَٰنِ الَّذِينَ يَمْشُونَ عَلَى الْأَرْضِ هَوْنًا وَإِذَا خَاطَبَهُمُ الْجَاهِلُونَ قَالُوا سَلَامًا",
             "And the servants of the Most Merciful are those who walk upon the earth easily, and when the ignorant address them [harshly], they say [words of] peace",
             "This verse describes the character of true believers - humble and peaceful"),
            
            // 7. Al-Isra 17:82 - The Quran as Healing
            (17, "Al-Isra", 82,
             "وَنُنَزِّلُ مِنَ الْقُرْآنِ مَا هُوَ شِفَاءٌ وَرَحْمَةٌ لِّلْمُؤْمِنِينَ",
             "And We send down of the Quran that which is healing and mercy for the believers",
             "This verse tells us about the healing and merciful nature of the Quran"),
            
            // 8. Al-Fatiha 1:5 - Seeking Help
            (1, "Al-Fatiha", 5,
             "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ",
             "It is You we worship and You we ask for help",
             "A central verse teaching us to direct our worship and seeking of help to Allah alone"),
            
            // 9. Al-Rahman 55:1-4 - Divine Teaching
            (55, "Al-Rahman", 1,
             "الرَّحْمَٰنُ ﴿١﴾ عَلَّمَ الْقُرْآنَ ﴿٢﴾ خَلَقَ الْإِنسَانَ ﴿٣﴾ عَلَّمَهُ الْبَيَانَ",
             "The Most Merciful, taught the Quran, created mankind, and taught him speech",
             "These verses highlight Allah's mercy in teaching humanity knowledge and communication"),
            
            // 10. Al-Mulk 67:2 - Purpose of Life
            (67, "Al-Mulk", 2,
             "الَّذِي خَلَقَ الْمَوْتَ وَالْحَيَاةَ لِيَبْلُوَكُمْ أَيُّكُمْ أَحْسَنُ عَمَلًا ۚ وَهُوَ الْعَزِيزُ الْغَفُورُ",
             "Who created death and life to test you as to which of you is best in deed - and He is the Exalted in Might, the Forgiving",
             "This verse explains the purpose of our existence and the test of life"),
            
            // 11. Al-Asr 103:1-3 - Value of Time
            (103, "Al-Asr", 1,
             "وَالْعَصْرِ ﴿١﴾ إِنَّ الْإِنسَانَ لَفِي خُسْرٍ ﴿٢﴾ إِلَّا الَّذِينَ آمَنُوا وَعَمِلُوا الصَّالِحَاتِ",
             "By time, indeed, mankind is in loss, except for those who have believed and done righteous deeds",
             "These verses emphasize the importance of time and righteous actions"),
            
            // 12. Al-Anfal 8:2 - Signs of True Believers
            (8, "Al-Anfal", 2,
             "إِنَّمَا الْمُؤْمِنُونَ الَّذِينَ إِذَا ذُكِرَ اللَّهُ وَجِلَتْ قُلُوبُهُمْ",
             "The believers are only those who, when Allah is mentioned, their hearts become fearful",
             "This verse describes one of the key characteristics of true believers"),
            
            // 13. Al-Zumar 39:53 - Divine Mercy
            (39, "Al-Zumar", 53,
             "قُلْ يَا عِبَادِيَ الَّذِينَ أَسْرَفُوا عَلَىٰ أَنفُسِهِمْ لَا تَقْنَطُوا مِن رَّحْمَةِ اللَّهِ",
             "Say, 'O My servants who have transgressed against themselves, do not despair of the mercy of Allah'",
             "A verse of hope, reminding us of Allah's vast mercy and forgiveness"),
            
            // 14. Al-Nahl 16:90 - Justice and Good Conduct
            (16, "Al-Nahl", 90,
             "إِنَّ اللَّهَ يَأْمُرُ بِالْعَدْلِ وَالْإِحْسَانِ وَإِيتَاءِ ذِي الْقُرْبَىٰ",
             "Indeed, Allah orders justice and good conduct and giving to relatives",
             "This verse outlines the fundamental principles of Islamic ethics"),
            
            // 15. Al-Hujurat 49:13 - Human Equality
            (49, "Al-Hujurat", 13,
             "يَا أَيُّهَا النَّاسُ إِنَّا خَلَقْنَاكُم مِّن ذَكَرٍ وَأُنثَىٰ وَجَعَلْنَاكُمْ شُعُوبًا وَقَبَائِلَ لِتَعَارَفُوا",
             "O mankind, indeed We have created you from male and female and made you peoples and tribes that you may know one another",
             "A verse promoting human equality and mutual understanding"),
            
            // 16. Al-Baqarah 2:186 - Closeness to Allah
            (2, "Al-Baqarah", 186,
             "وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ ۖ أُجِيبُ دَعْوَةَ الدَّاعِ إِذَا دَعَانِ",
             "And when My servants ask you concerning Me - indeed I am near. I respond to the invocation of the supplicant when he calls upon Me",
             "This verse assures us of Allah's closeness and His response to our prayers"),

            // Continue with more verses...
            // Would you like me to add more verses with different themes?
        ]
    }
} 