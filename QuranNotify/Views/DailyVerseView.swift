import SwiftUI

struct DailyVerseView: View {
    @StateObject private var verseViewModel = DailyVerseViewModel()
    @StateObject private var hadeesViewModel = DailyHadeesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Quran Verse Section
                    if let verse = verseViewModel.todayVerse {
                        VStack(spacing: 16) {
                            Text("Today's Quranic Verse")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text("Day \(verse.dayOfYear) of 365")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(verse.arabicText)
                                    .font(.title)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                
                                Text(verse.translation)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    verseViewModel.showFullExplanation = true
                                }) {
                                    Text("Read More")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                    }
                    
                    Divider()
                        .padding(.horizontal)
                    
                    // Hadees Section
                    if let hadees = hadeesViewModel.todayHadees {
                        VStack(spacing: 16) {
                            Text("Today's Hadees")
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text(hadees.arabicText)
                                    .font(.title3)
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity)
                                
                                Text(hadees.translation)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                
                                Text("Narrated by: \(hadees.narratedBy)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("Source: \(hadees.source)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                Button(action: {
                                    hadeesViewModel.showFullExplanation = true
                                }) {
                                    Text("Read More")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.bordered)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Daily Guidance")
            .sheet(isPresented: $verseViewModel.showFullExplanation) {
                if let verse = verseViewModel.todayVerse {
                    VerseDetailView(verse: verse)
                }
            }
            .sheet(isPresented: $hadeesViewModel.showFullExplanation) {
                if let hadees = hadeesViewModel.todayHadees {
                    HadeesDetailView(hadees: hadees)
                }
            }
        }
    }
}

#Preview {
    DailyVerseView()
} 