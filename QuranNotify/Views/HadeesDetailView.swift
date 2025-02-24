import SwiftUI

struct HadeesDetailView: View {
    let hadees: Hadees?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let hadees = hadees {
                    Text(hadees.arabicText)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text(hadees.translation)
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Narrated by: \(hadees.narratedBy)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Source: \(hadees.source)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Reference: \(hadees.bookReference)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    Text(hadees.explanation)
                        .padding()
                }
            }
        }
        .navigationTitle("Hadees \(hadees?.dayOfYear ?? 0)")
    }
} 