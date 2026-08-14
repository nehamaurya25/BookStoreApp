//
// PaymentScreen.swift
// BookstoreApp
//

import SwiftUI

/// Payment method selection and final order summary before purchase.
struct PaymentScreen: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @EnvironmentObject private var authVM: AuthViewModel
    @EnvironmentObject private var orderVM: OrderViewModel

    let selectedAddress: Address
    var onPaymentComplete: (Order) -> Void = { _ in }
    @Environment(\.dismiss) private var dismiss

    @State private var selectedMethod: PaymentMethod = .applePay
    @State private var isProcessing: Bool = false

    enum PaymentMethod: String, CaseIterable, Identifiable {
        case applePay    = "Apple Pay"
        case creditCard  = "Credit / Debit Card"
        case upi         = "UPI"
        case netBanking  = "Net Banking"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .applePay:   return "applelogo"
            case .creditCard: return "creditcard.fill"
            case .upi:        return "indianrupeesign.circle.fill"
            case .netBanking: return "building.columns.fill"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppSpacing.lg) {

                    // Delivery address summary
                    addressSummary

                    // Payment method picker
                    paymentMethodSection

                    // Order breakdown
                    orderSummarySection

                    // Pay CTA
                    PrimaryButton(
                        title: isProcessing ? "Processing…" : "Pay \(cartVM.formattedTotal(for: authVM.currentUser))",
                        icon: isProcessing ? nil : "lock.fill",
                        isLoading: isProcessing,
                        style: .filled
                    ) {
                        processPayment()
                    }
                    .padding(.horizontal, AppSpacing.md)
                    .padding(.bottom, AppSpacing.xl)
                }
                .padding(.top, AppSpacing.md)
            }
            .background(AppColors.groupedBackground)
            .navigationTitle("Payment")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") { dismiss() }
                        .foregroundColor(AppColors.primary)
                }
            }
        }
    }

    // MARK: - Address Summary

    private var addressSummary: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: "location.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppColors.primary)

            VStack(alignment: .leading, spacing: 2) {
                Text("Delivering to")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                Text(selectedAddress.recipientName)
                    .font(AppFonts.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                Text(selectedAddress.singleLineFormat)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .padding(.horizontal, AppSpacing.md)
    }

    // MARK: - Payment Methods

    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Payment Method")
                .padding(.horizontal, AppSpacing.md)

            VStack(spacing: 0) {
                ForEach(PaymentMethod.allCases) { method in
                    paymentRow(method)
                    if method != PaymentMethod.allCases.last {
                        Divider().padding(.leading, 56)
                    }
                }
            }
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .padding(.horizontal, AppSpacing.md)
        }
    }

    private func paymentRow(_ method: PaymentMethod) -> some View {
        let isSelected = selectedMethod == method
        return Button { selectedMethod = method } label: {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: method.icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textSecondary)
                    .frame(width: 28)

                Text(method.rawValue)
                    .font(AppFonts.subheadline)
                    .foregroundColor(AppColors.textPrimary)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.border)
            }
            .padding(AppSpacing.md)
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Order Summary

    private var orderSummarySection: some View {
        VStack(spacing: AppSpacing.sm) {
            SectionHeader(title: "Order Summary")
                .padding(.horizontal, AppSpacing.md)

            VStack(spacing: AppSpacing.sm) {
                summaryRow("Items (\(cartVM.items.count))",
                           String(format: "$%.2f", cartVM.subtotal))

                summaryRow("Shipping",
                           cartVM.shippingFee > 0
                               ? String(format: "$%.2f", cartVM.shippingFee)
                               : "FREE",
                           valueColor: cartVM.shippingFee == 0 ? AppColors.success : AppColors.textPrimary)

                if cartVM.isRedeemingPoints,
                   let user = authVM.currentUser {
                    let disc = cartVM.pointsDiscount(for: user)
                    if disc > 0 {
                        summaryRow("Points Discount",
                                   String(format: "-$%.2f", disc),
                                   valueColor: AppColors.success)
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
    }

    private func summaryRow(_ label: String, _ value: String, valueColor: Color = AppColors.textPrimary) -> some View {
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

    // MARK: - Payment Processing

    private func processPayment() {
        guard !isProcessing else { return }
        isProcessing = true

        // Simulate a short processing delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            let pointsRedeemed = cartVM.isRedeemingPoints
                ? Int((cartVM.pointsDiscount(for: authVM.currentUser) / 0.05).rounded())
                : 0

            let order = orderVM.placeOrder(
                from: cartVM.items,
                address: selectedAddress,
                paymentMethod: selectedMethod.rawValue,
                subtotal: cartVM.subtotal,
                discount: cartVM.pointsDiscount(for: authVM.currentUser),
                shipping: cartVM.shippingFee,
                total: cartVM.total(for: authVM.currentUser),
                pointsRedeemed: pointsRedeemed
            )

            // Deduct points if redeemed
            if cartVM.isRedeemingPoints {
                authVM.redeemGiftPoints(pointsRedeemed)
            }

            cartVM.clearCart()
            isProcessing = false
            onPaymentComplete(order)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct PaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        PaymentScreen(selectedAddress: MockData.sampleAddresses[0])
            .environmentObject(CartViewModel())
            .environmentObject(AuthViewModel())
            .environmentObject(OrderViewModel())
    }
}
#endif
