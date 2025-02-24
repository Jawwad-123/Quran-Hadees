import SwiftUI

struct DailyHadeesView: View {
    @StateObject private var viewModel = DailyHadeesViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if let hadees = viewModel.todayHadees {
                        Text("Day \(hadees.dayOfYear) of 365")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text(hadees.arabicText)
                                .font(.title)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)
                            
                            Text(hadees.translation)
                                .font(.body)
                                .foregroundColor(.secondary)
                            
                            Text("Narrated by: \(hadees.narratedBy)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                viewModel.showFullExplanation = true
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
                        .padding()
                    } else {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .navigationTitle("Today's Hadees")
        }
    }
} 