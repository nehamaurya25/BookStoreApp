import SwiftUI

enum AppLayout {
    static let contentMaxWidth: CGFloat = 720
    static let compactCardWidth: CGFloat = 160
    static let regularCardWidth: CGFloat = 220
    static let heroBannerHeight: CGFloat = 220
    static let coverAspectRatio: CGFloat = 0.68

    static func horizontalPadding(for width: CGFloat) -> CGFloat {
        switch width {
        case ..<375:
            return AppSpacing.sm
        case ..<768:
            return AppSpacing.md
        default:
            return AppSpacing.lg
        }
    }

    static func gridColumns(for width: CGFloat) -> [GridItem] {
        let minimum: CGFloat
        switch width {
        case ..<375:
            minimum = 140
        case ..<768:
            minimum = 160
        default:
            minimum = 200
        }

        return [GridItem(.adaptive(minimum: minimum), spacing: AppSpacing.md, alignment: .top)]
    }

    static func featuredColumns(for width: CGFloat) -> Int {
        switch width {
        case ..<768:
            return 1
        default:
            return 2
        }
    }
}
