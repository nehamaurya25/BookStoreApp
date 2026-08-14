//
// BrandCard.swift
// BookstoreApp
//

import SwiftUI

/// Publisher/brand card showing logo icon, name, title count, and country badge.
/// Supports selected highlight for use in filterable brand pickers.
struct BrandCard: View {
    let brand: BrandPublisher
    var isSelected: Bool = false
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                HStack(spacing: AppSpacing.sm) {
                    // Logo icon
                    ZStack {
                        RoundedRectangle(cornerRadius: AppRadius.sm)
                            .fill(AppColors.primary.opacity(0.10))
                            .frame(width: 44, height: 44)
                        Image(systemName: brand.logoIcon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(AppColors.primary)
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        Text(brand.name)
                            .font(AppFonts.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(1)

                        Text("\(brand.titleCount) titles")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Spacer(minLength: 0)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18))
                            .foregroundColor(AppColors.primary)
                    }
                }

                // Country badge
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "globe")
                        .font(.system(size: 10))
                    Text(brand.country)
                        .font(AppFonts.caption2)
                }
                .foregroundColor(AppColors.textTertiary)
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, 3)
                .background(AppColors.secondaryBackground)
                .clipShape(Capsule())
            }
            .padding(AppSpacing.md)
            .background(isSelected ? AppColors.primary.opacity(0.06) : AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .strokeBorder(
                        isSelected ? AppColors.primary : AppColors.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Preview

#if DEBUG
struct BrandCard_Previews: PreviewProvider {
    static let sample = BrandPublisher(
        id: "b1",
        name: "Penguin Random House",
        logoIcon: "building.columns.fill",
        country: "United States",
        foundedYear: 1927,
        titleCount: 5400,
        isPopular: true
    )

    static var previews: some View {
        VStack(spacing: AppSpacing.md) {
            BrandCard(brand: sample, isSelected: false, onTap: {})
            BrandCard(brand: sample, isSelected: true, onTap: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
