//
// PaymentConfirmationView.swift
// BookstoreApp
//

import SwiftUI

/// Full-screen purchase success screen shown after payment completes.
/// Displays animated checkmark, order number, summary, and navigation CTAs.
struct PaymentConfirmationView: View {
    let order: Order
    var onViewOrder: (Order) -> Void = { _ in }
    var onContinueShopping: () -> Void = {}

    @State private var checkmarkScale: CGFloat = 0.3
    @State private var checkmarkOpacity: Double = 0
    @State private var contentOpacity: Double = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.xl) {

                    // Animated success badge
                    successBadge
                        .padding(.top, AppSpacing.xxl)

                    // Order confirmed headline
                    VStack(spacing: AppSpacing.xs) {
                        Text("Order Confirmed!")
                            .font(AppFonts.title2)
                            .foregroundColor(AppColors.textPrimary)
                        Text("Order \(order.orderNumber)")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    // Order items summary
                    orderItemsCard

                    // Delivery info
                    deliveryCard

                    // Points earned
                    if order.pointsEarned > 0 {
                        pointsEarnedCard
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.xxl)
                .opacity(contentOpacity)
            }

            // Bottom CTAs
            VStack(spacing: AppSpacing.sm) {
                Divider()
                PrimaryButton(title: "View Order Details", icon: "list.bullet.rectangle", style: .filled) {
                    onViewOrder(order)
                }
                .padding(.horizontal, AppSpacing.md)

                PrimaryButton(title: "Continue Shopping", icon: "books.vertical", style: .outline) {
                    onContinueShopping()
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.bottom, AppSpacing.md)
            }
            .background(AppColors.background)
            .opacity(contentOpacity)
        }
        .background(AppColors.groupedBackground)
        .navigationBarBackButtonHidden(true)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .onAppear { runEntryAnimation() }
    }

    // MARK: - Success Badge

    private var successBadge: some View {
        ZStack {
            Circle()
                .fill(AppColors.success.opacity(0.12))
                .frame(width: 120, height: 120)
            Circle()
                .fill(AppColors.success.opacity(0.2))
                .frame(width: 90, height: 90)
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56, weight: .regular))
                .foregroundColor(AppColors.success)
        }
        .scaleEffect(checkmarkScale)
        .opacity(checkmarkOpacity)
    }

    // MARK: - Order Items Card

    private var orderItemsCard: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Items Ordered")

            ForEach(order.items) { item in
                HStack(spacing: AppSpacing.md) {
                    ZStack {
                        Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                            .opacity(0.25)
                        Image(systemName: item.book.coverImageName)
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))
                    }
                    .frame(width: 44, height: 44 / AppLayout.coverAspectRatio)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.book.title)
                            .font(AppFonts.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                            .lineLimit(1)
                        Text("\(item.selectedFormat) × \(item.quantity)")
                            .font(AppFonts.caption1)
                            .foregroundColor(AppColors.textSecondary)
                    }

                    Spacer()

                    Text(item.formattedTotalPrice)
                        .font(AppFonts.priceSmall)
                        .foregroundColor(AppColors.textPrimary)
                }
            }

            Divider()

            HStack {
                Text("Total Paid")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text(order.formattedTotal)
                    .font(AppFonts.price)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }

    // MARK: - Delivery Card

    private var deliveryCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "shippingbox.fill")
                .font(.system(size: 28))
                .foregroundColor(AppColors.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Estimated Delivery")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                // Use fastest delivery from items
                let fastest = order.items.min(by: { $0.book.estimatedDeliveryDays < $1.book.estimatedDeliveryDays })
                Text(fastest?.book.tentativeDeliveryDateString ?? "2–3 business days")
                    .font(AppFonts.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                Text(order.shippingAddress.singleLineFormat)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }

    // MARK: - Points Earned Card

    private var pointsEarnedCard: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(AppColors.accent)
            VStack(alignment: .leading, spacing: 2) {
                Text("You earned \(order.pointsEarned) Gift Points!")
                    .font(AppFonts.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                Text("Worth \(String(format: "$%.2f", Double(order.pointsEarned) * 0.05)) on your next order")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.saleBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
    }

    // MARK: - Animation

    private func runEntryAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.1)) {
            checkmarkScale = 1.0
            checkmarkOpacity = 1.0
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.4)) {
            contentOpacity = 1.0
        }
    }
}

// MARK: - Preview

#if DEBUG
struct PaymentConfirmationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PaymentConfirmationView(order: MockData.sampleOrders[0])
        }
    }
}
#endif
