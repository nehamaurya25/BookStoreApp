//
// CategoryChip.swift
// BookstoreApp
//

import SwiftUI

/// Pill-shaped button for category filtering with selected and unselected states.
struct CategoryChip: View {
    let category: Category
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: category.systemIcon)
                    .font(.system(size: 13, weight: .medium))

                Text(category.name)
                    .font(AppFonts.footnote)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : AppColors.textPrimary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? AppColors.primary : AppColors.secondaryBackground)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isSelected ? Color.clear : AppColors.border,
                        lineWidth: 1
                    )
            )
        }
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

/// Convenience chip variant using a plain string label (no icon, no Category model).
struct PlainChip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(AppFonts.footnote)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : AppColors.textPrimary)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(isSelected ? AppColors.primary : AppColors.secondaryBackground)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? Color.clear : AppColors.border,
                            lineWidth: 1
                        )
                )
        }
        .animation(.easeInOut(duration: 0.18), value: isSelected)
    }
}

// MARK: - Preview

#if DEBUG
struct CategoryChip_Previews: PreviewProvider {
    static let sample = Category(id: "c1", name: "Fiction", systemIcon: "book.fill", description: "Novels and stories", bookCount: 120)

    static var previews: some View {
        VStack(spacing: AppSpacing.md) {
            HStack {
                CategoryChip(category: sample, isSelected: true, onTap: {})
                CategoryChip(category: sample, isSelected: false, onTap: {})
            }
            HStack {
                PlainChip(label: "All", isSelected: true, onTap: {})
                PlainChip(label: "Science", isSelected: false, onTap: {})
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
