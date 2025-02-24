import SwiftUI

struct AllVersesView: View {
    @StateObject private var viewModel = AllVersesViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.verses) { verse in
                NavigationLink(destination: VerseDetailView(verse: verse)) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Day \(verse.dayOfYear)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        Text(verse.translation)
                            .lineLimit(2)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("All Verses")
            .searchable(text: $viewModel.searchText)
        }
    }
} 