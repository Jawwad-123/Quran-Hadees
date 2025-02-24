import SwiftUI

struct AllHadeesView: View {
    @StateObject private var viewModel = AllHadeesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.hadees) { hadees in
                NavigationLink(destination: HadeesDetailView(hadees: hadees)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Day \(hadees.dayOfYear)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(hadees.translation)
                            .lineLimit(2)
                        
                        Text("Narrated by: \(hadees.narratedBy)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("All Hadees")
            .searchable(text: $viewModel.searchText)
        }
    }
} 