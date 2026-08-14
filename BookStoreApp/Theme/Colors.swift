import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64

        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum AppColors {
    static let primary = Color(hex: "5B3FD0")
    static let primaryDark = Color(hex: "4127A6")
    static let primaryLight = Color(hex: "8D79E8")

    static let accent = Color(hex: "F59E0B")
    static let accentSoft = Color(hex: "FDE68A")

    static let success = Color(hex: "15803D")
    static let warning = Color(hex: "D97706")
    static let error = Color(hex: "DC2626")

    static let background = Color(.white)
    static let secondaryBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let groupedBackground = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let surface = Color(.white)
    static let cardBackground = Color(.white)

    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let textTertiary = Color.secondary.opacity(0.6)
    static let textOnPrimary = Color.white

    static let border = Color(red: 0.78, green: 0.78, blue: 0.80)
    static let divider = Color(red: 0.78, green: 0.78, blue: 0.80)
    static let badgeBackground = Color(hex: "EEF2FF")
    static let saleBackground = Color(hex: "FEF3C7")
}