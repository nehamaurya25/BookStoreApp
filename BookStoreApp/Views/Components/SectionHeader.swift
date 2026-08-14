//
// SectionHeader.swift
// BookstoreApp
//

import SwiftUI

/// Section title row with optional "See All" navigation button.
struct SectionHeader: View {
    let title: String
    var subtitle: String? = nil
    var seeAllLabel: String = "See All"
    var onSeeAll: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title)
                    .font(AppFonts.title3)
                    .foregroundColor(AppColors.textPrimary)

                if let subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            Spacer()

            if let action = onSeeAll {
                Button(action: action) {
                    HStack(spacing: 3) {
                        Text(seeAllLabel)
                            .font(AppFonts.footnote)
                            .fontWeight(.medium)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: AppSpacing.lg) {
            SectionHeader(title: "Featured Books", onSeeAll: {})
            SectionHeader(title: "New Arrivals", subtitle: "Added this week", onSeeAll: {})
            SectionHeader(title: "My Orders")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
