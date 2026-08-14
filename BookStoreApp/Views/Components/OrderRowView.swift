//
// OrderRowView.swift
// BookstoreApp
//

import SwiftUI

/// Order item row for order history screens.
/// Shows order number, date, status badge, item thumbnails, total amount,
/// a "Buy Again" quick-action button, and a cancellation countdown tag when eligible.
struct OrderRowView: View {
    let order: Order
    let onBuyAgain: () -> Void
    let onCancel: () -> Void
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Top row: order number + status badge
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Order \(order.orderNumber)")
                            .font(AppFonts.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        Text(order.formattedOrderDate)
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    Spacer()
                    statusBadge
                }

                // Book cover thumbnails (up to 4)
                coverThumbnailRow

                // Cancellation countdown tag (only shown when eligible)
                if order.canBeCancelled {
                    cancellationTag
                }

                // Bottom row: total + actions
                HStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Total")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.textSecondary)
                        Text(order.formattedTotal)
                            .font(AppFonts.priceSmall)
                            .foregroundColor(AppColors.textPrimary)
                    }

                    Spacer()

                    HStack(spacing: AppSpacing.sm) {
                        // Cancel order (only while eligible)
                        if order.canBeCancelled {
                            Button(action: onCancel) {
                                Text("Cancel")
                                    .font(AppFonts.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(AppColors.error)
                                    .padding(.horizontal, AppSpacing.md)
                                    .padding(.vertical, AppSpacing.xs)
                                    .background(AppColors.error.opacity(0.08))
                                    .clipShape(Capsule())
                            }
                        }

                        // Buy Again
                        Button(action: onBuyAgain) {
                            Label("Buy Again", systemImage: "arrow.clockwise")
                                .font(AppFonts.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.horizontal, AppSpacing.md)
                                .padding(.vertical, AppSpacing.xs)
                                .background(AppColors.primary)
                                .clipShape(Capsule())
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .shadow(color: .black.opacity(AppShadow.cardOpacity),
                    radius: AppShadow.cardRadius,
                    x: 0, y: AppShadow.cardYOffset)
        }
        .buttonStyle(.plain)
    }

    // MARK: Subviews

    private var statusBadge: some View {
        Text(order.status.rawValue)
            .font(AppFonts.caption2)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: order.status.badgeColorHex))
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xxs + 1)
            .background(Color(hex: order.status.badgeColorHex).opacity(0.12))
            .clipShape(Capsule())
    }

    private var coverThumbnailRow: some View {
        HStack(spacing: AppSpacing.sm) {
            ForEach(order.items.prefix(4)) { item in
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(Color(hex: item.book.coverColorHex.trimmingCharacters(
                            in: CharacterSet(charactersIn: "#")
                        )).opacity(0.25))
                        .frame(width: 44, height: 64)
                    Image(systemName: item.book.coverImageName)
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(Color(hex: item.book.coverColorHex.trimmingCharacters(
                            in: CharacterSet(charactersIn: "#")
                        )))
                }
            }

            if order.items.count > 4 {
                Text("+\(order.items.count - 4)")
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textTertiary)
                    .frame(width: 44, height: 64)
                    .background(AppColors.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
            }

            Spacer(minLength: 0)
        }
    }

    private var cancellationTag: some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: "clock")
                .font(.system(size: 11))
            Text("Cancel within \(order.remainingCancelHours)h")
                .font(AppFonts.caption2)
                .fontWeight(.medium)
        }
        .foregroundColor(AppColors.warning)
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, 4)
        .background(AppColors.warning.opacity(0.10))
        .clipShape(Capsule())
    }
}

// MARK: - Preview

#if DEBUG
struct OrderRowView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                // Uses first order from mock data if available, otherwise shows placeholder text
                Text("Order Row Preview")
                    .font(AppFonts.headline)
                    .padding(.bottom, AppSpacing.sm)
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
