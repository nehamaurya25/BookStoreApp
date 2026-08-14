//
// ShoppingCartView.swift
// BookstoreApp
//

import SwiftUI

/// Shopping cart screen showing line items, pricing breakdown,
/// gift-point redemption toggle, and order-history based recommendations.
struct ShoppingCartView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @EnvironmentObject private var authVM: AuthViewModel

    let pastOrders: [Order]
    var onCheckout: () -> Void = {}
    var onBookTap: (Book) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            Group {
                if cartVM.items.isEmpty {
                    emptyState
                } else {
                    filledCart
                }
            }
            .navigationTitle("Your Cart")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .background(AppColors.groupedBackground)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: AppSpacing.lg) {
            Spacer()
            Image(systemName: "bag")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(AppColors.textTertiary)
            Text("Your cart is empty")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)
            Text("Add books from the catalogue to get started.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            Spacer()
        }
    }

    // MARK: - Filled Cart

    private var filledCart: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppSpacing.lg) {

                // Line items
                cartItemsSection

                // Gift points toggle
                giftPointsSection

                // Order summary
                summarySection

                // Recommendations
                let recs = cartVM.recommendations(from: pastOrders)
                if !recs.isEmpty {
                    recommendationsSection(recs)
                }

                // Checkout CTA
                PrimaryButton(
                    title: "Proceed to Checkout",
                    icon: "creditcard",
                    style: .filled
                ) { onCheckout() }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xl)
            }
            .padding(.top, AppSpacing.md)
        }
        .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 1) }
    }

    // MARK: - Cart Items

    private var cartItemsSection: some View {
        VStack(spacing: 0) {
            ForEach(cartVM.items) { item in
                cartRow(item)
                if item.id != cartVM.items.last?.id { Divider().padding(.leading, 88) }
            }
        }
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    private func cartRow(_ item: CartItem) -> some View {
        HStack(spacing: AppSpacing.md) {
            // Cover thumbnail
            ZStack {
                Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                    .opacity(0.25)
                Image(systemName: item.book.coverImageName)
                    .font(.system(size: 24, weight: .light))
                    .foregroundColor(Color(hex: item.book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))
            }
            .frame(width: 56, height: 56 / AppLayout.coverAspectRatio)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            // Info
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(item.book.title)
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                Text(item.selectedFormat)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                Text(item.formattedTotalPrice)
                    .font(AppFonts.priceSmall)
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            // Stepper
            HStack(spacing: 0) {
                stepperButton(icon: "minus") {
                    cartVM.updateQuantity(item, quantity: item.quantity - 1)
                }
                Text("\(item.quantity)")
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .frame(width: 32)
                    .multilineTextAlignment(.center)
                stepperButton(icon: "plus") {
                    cartVM.updateQuantity(item, quantity: item.quantity + 1)
                }
            }
            .background(AppColors.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
        }
        .padding(AppSpacing.md)
    }

    private func stepperButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(AppColors.primary)
                .frame(width: 30, height: 30)
        }
    }

    // MARK: - Gift Points

    private var giftPointsSection: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(AppColors.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text("Gift Points")
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                if let user = authVM.currentUser {
                    Text("\(user.giftPointsBalance) pts — worth \(user.formattedGiftPointsValue)")
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            Spacer()

            Toggle("", isOn: $cartVM.isRedeemingPoints)
                .tint(AppColors.primary)
                .labelsHidden()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    // MARK: - Order Summary

    private var summarySection: some View {
        VStack(spacing: AppSpacing.sm) {
            summaryRow(label: "Subtotal", value: String(format: "$%.2f", cartVM.subtotal))

            if cartVM.shippingFee > 0 {
                summaryRow(label: "Shipping", value: String(format: "$%.2f", cartVM.shippingFee))
            } else {
                summaryRow(label: "Shipping", value: "FREE", valueColor: AppColors.success)
            }

            if cartVM.isRedeemingPoints, let user = authVM.currentUser {
                let disc = cartVM.pointsDiscount(for: user)
                if disc > 0 {
                    summaryRow(
                        label: "Points Discount",
                        value: String(format: "-$%.2f", disc),
                        valueColor: AppColors.success
                    )
                }
            }

            Divider()

            HStack {
                Text("Total")
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.textPrimary)
                Spacer()
                Text(cartVM.formattedTotal(for: authVM.currentUser))
                    .font(AppFonts.price)
                    .foregroundColor(AppColors.textPrimary)
            }
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    private func summaryRow(label: String, value: String, valueColor: Color = AppColors.textPrimary) -> some View {
        HStack {
            Text(label)
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value)
                .font(AppFonts.subheadline)
                .fontWeight(.medium)
                .foregroundColor(valueColor)
        }
    }

    // MARK: - Recommendations

    private func recommendationsSection(_ books: [Book]) -> some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Because You Ordered")
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(books) { book in
                        BookCard(book: book, mode: .grid, onAddToCart: {
                            cartVM.addItem(book)
                        }, onTap: {
                            onBookTap(book)
                        })
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        let cartVM = CartViewModel()
        let _ = MockData.sampleBooks.prefix(2).forEach { cartVM.addItem($0) }
        return ShoppingCartView(pastOrders: MockData.sampleOrders)
            .environmentObject(cartVM)
            .environmentObject(AuthViewModel())
    }
}
#endif
