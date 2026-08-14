//
// OrderDetailView.swift
// BookstoreApp
//

import SwiftUI

/// Single order detail screen with full breakdown and cancellation CTA.
struct OrderDetailView: View {
    @EnvironmentObject private var orderVM: OrderViewModel
    @EnvironmentObject private var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss

    let order: Order

    /// Live version of the order so cancellation updates reflect immediately.
    private var liveOrder: Order {
        orderVM.orders.first(where: { $0.id == order.id }) ?? order
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.lg) {

                // Status banner
                statusBanner

                // Items list
                itemsSection

                // Pricing breakdown
                pricingSection

                // Delivery & payment info
                deliveryPaymentSection

                // Cancel CTA (only when eligible)
                if liveOrder.canBeCancelled {
                    cancelSection
                }

                // Buy Again
                PrimaryButton(
                    title: "Buy These Again",
                    icon: "arrow.clockwise",
                    style: .outline
                ) {
                    let items = orderVM.buyAgainItems(for: liveOrder)
                    items.forEach { cartVM.addItem($0.book, format: $0.selectedFormat) }
                    dismiss()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .background(AppColors.groupedBackground)
        .navigationTitle("Order \(liveOrder.orderNumber)")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }

    // MARK: - Status Banner

    private var statusBanner: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: statusIcon)
                .font(.system(size: 28))
                .foregroundColor(Color(hex: liveOrder.status.badgeColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))

            VStack(alignment: .leading, spacing: 2) {
                Text(liveOrder.status.rawValue)
                    .font(AppFonts.headline)
                    .foregroundColor(Color(hex: liveOrder.status.badgeColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))
                Text(liveOrder.formattedOrderDate)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            if liveOrder.canBeCancelled {
                cancellationCountdown
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    private var statusIcon: String {
        switch liveOrder.status {
        case .processing: return "clock.fill"
        case .shipped:    return "shippingbox.fill"
        case .delivered:  return "checkmark.circle.fill"
        case .cancelled:  return "xmark.circle.fill"
        }
    }

    private var cancellationCountdown: some View {
        VStack(spacing: 2) {
            Text("\(liveOrder.remainingCancelHours)h")
                .font(AppFonts.badge)
                .fontWeight(.bold)
                .foregroundColor(AppColors.warning)
            Text("to cancel")
                .font(AppFonts.caption2)
                .foregroundColor(AppColors.textTertiary)
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.saleBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
    }

    // MARK: - Items

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Items")
                .padding(.horizontal, AppSpacing.md)

            VStack(spacing: 0) {
                ForEach(liveOrder.items) { item in
                    HStack(spacing: AppSpacing.md) {
                        ZStack {
                            Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                                .opacity(0.25)
                            Image(systemName: item.book.coverImageName)
                                .font(.system(size: 20, weight: .light))
                                .foregroundColor(Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))
                        }
                        .frame(width: 52, height: 52 / AppLayout.coverAspectRatio)
                        .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.book.title)
                                .font(AppFonts.footnote)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.textPrimary)
                                .lineLimit(2)
                            Text(item.book.author)
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textSecondary)
                            Text("\(item.selectedFormat) × \(item.quantity)")
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textTertiary)
                        }

                        Spacer()

                        Text(item.formattedTotalPrice)
                            .font(AppFonts.priceSmall)
                            .foregroundColor(AppColors.textPrimary)
                    }
                    .padding(AppSpacing.md)

                    if item.id != liveOrder.items.last?.id {
                        Divider().padding(.leading, 72)
                    }
                }
            }
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .padding(.horizontal, AppSpacing.md)
        }
    }

    // MARK: - Pricing

    private var pricingSection: some View {
        VStack(spacing: AppSpacing.sm) {
            pricingRow("Subtotal", String(format: "$%.2f", liveOrder.subtotal))

            if liveOrder.discountAmount > 0 {
                pricingRow("Discount", String(format: "-$%.2f", liveOrder.discountAmount), color: AppColors.success)
            }
            if liveOrder.shippingFee > 0 {
                pricingRow("Shipping", String(format: "$%.2f", liveOrder.shippingFee))
            } else {
                pricingRow("Shipping", "FREE", color: AppColors.success)
            }
            if liveOrder.pointsRedeemed > 0 {
                pricingRow("Points Redeemed", "\(liveOrder.pointsRedeemed) pts", color: AppColors.success)
            }

            Divider()

            HStack {
                Text("Total")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text(liveOrder.formattedTotal)
                    .font(AppFonts.price)
                    .foregroundColor(AppColors.textPrimary)
            }

            if liveOrder.pointsEarned > 0 {
                HStack {
                    Image(systemName: "star.fill")
                        .font(.system(size: 11))
                        .foregroundColor(AppColors.accent)
                    Text("Earned \(liveOrder.pointsEarned) Gift Points on this order")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                    Spacer()
                }
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    private func pricingRow(_ label: String, _ value: String, color: Color = AppColors.textPrimary) -> some View {
        HStack {
            Text(label)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(AppFonts.subheadline)
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }

    // MARK: - Delivery & Payment

    private var deliveryPaymentSection: some View {
        VStack(spacing: AppSpacing.sm) {
            // Delivery address
            infoRow(
                icon: "location.circle.fill",
                title: "Delivered to",
                detail: liveOrder.shippingAddress.singleLineFormat
            )

            Divider().padding(.leading, 44)

            // Payment method
            infoRow(
                icon: "creditcard.fill",
                title: "Payment",
                detail: liveOrder.paymentMethodName
            )
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    private func infoRow(icon: String, title: String, detail: String) -> some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColors.primary)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                Text(detail)
                    .font(AppFonts.footnote)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
            }
            Spacer()
        }
    }

    // MARK: - Cancel Section

    private var cancelSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Text("You can cancel this order within \(liveOrder.remainingCancelHours) hour\(liveOrder.remainingCancelHours == 1 ? "" : "s")")
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)

            PrimaryButton(
                title: "Cancel Order",
                icon: "xmark.circle",
                style: .outline
            ) {
                orderVM.cancelOrder(liveOrder)
            }
            .padding(.horizontal, AppSpacing.md)
        }
        .padding(.top, AppSpacing.xs)
    }
}

// MARK: - Preview

#if DEBUG
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OrderDetailView(order: MockData.sampleOrders[0])
                .environmentObject(OrderViewModel())
                .environmentObject(CartViewModel())
        }
    }
}
#endif
