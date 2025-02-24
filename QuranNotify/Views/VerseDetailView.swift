import SwiftUI

struct VerseDetailView: View {
    let verse: QuranVerse?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let verse = verse {
                    Text(verse.arabicText)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text(verse.translation)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Text(verse.explanation)
                        .padding()
                }
            }
        }
        .navigationTitle("Verse \(verse?.verseNumber ?? 0)")
    }
} 