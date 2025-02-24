import SwiftUI

struct AppIconPreview: View {
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(hex: "1E4D6B"),  // Deep blue
                    Color(hex: "0A2F44")   // Darker blue
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Islamic geometric pattern
            GeometricPattern()
                .opacity(0.1)
            
            // Main elements
            ZStack {
                // Crescent
                Circle()
                    .trim(from: 0.6, to: 1.0)
                    .rotation(.degrees(45))
                    .stroke(Color.white, lineWidth: 8)
                    .frame(width: 70, height: 70)
                
                // Notification dot
                Circle()
                    .fill(Color(hex: "FFD700"))  // Gold color
                    .frame(width: 12, height: 12)
                    .offset(x: 30, y: -30)
            }
            .shadow(color: .black.opacity(0.2), radius: 10)
        }
        .frame(width: 1024, height: 1024)  // App Store size
    }
}

// Helper for geometric pattern
struct GeometricPattern: View {
    var body: some View {
        Path { path in
            // Islamic geometric pattern
            let size: CGFloat = 100
            let count = 12
            
            for i in 0..<count {
                let angle = (2 * .pi * CGFloat(i)) / CGFloat(count)
                let x = cos(angle) * size
                let y = sin(angle) * size
                
                path.move(to: CGPoint(x: x, y: y))
                path.addLine(to: .zero)
            }
        }
        .stroke(Color.white, lineWidth: 1)
    }
}

// Helper for hex colors
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    AppIconPreview()
} 