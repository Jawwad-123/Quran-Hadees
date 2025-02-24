import SwiftUI

class DailyHadeesViewModel: ObservableObject {
    @Published var todayHadees: Hadees?
    @Published var showFullExplanation = false
    private let allHadees = AllHadeesViewModel()
    
    init() {
        updateTodayHadees()
    }
    
    func updateTodayHadees() {
        todayHadees = allHadees.getTodayHadees()
    }
} 