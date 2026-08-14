//
// CheckoutAddressView.swift
// BookstoreApp
//

import SwiftUI

/// Delivery address selection screen shown during checkout.
/// Lists saved addresses with a default badge and allows picking one.
struct CheckoutAddressView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @Environment(\.dismiss) private var dismiss

    var onConfirm: (Address) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: AppSpacing.md) {
                    ForEach(cartVM.addresses) { address in
                        addressCard(address)
                    }
                }
                .padding(AppSpacing.md)
                .padding(.bottom, AppSpacing.xl)
            }
            .background(AppColors.groupedBackground)
            .navigationTitle("Delivery Address")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppColors.primary)
                }
            }
            .safeAreaInset(edge: .bottom) {
                confirmBar
            }
        }
    }

    // MARK: - Address Card

    private func addressCard(_ address: Address) -> some View {
        let isSelected = cartVM.selectedAddressId == address.id

        return Button {
            cartVM.selectedAddressId = address.id
        } label: {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                // Icon
                Image(systemName: "location.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.textTertiary)

                // Details
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    HStack(spacing: AppSpacing.xs) {
                        Text(address.recipientName)
                            .font(AppFonts.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColors.textPrimary)
                        if address.isDefault {
                            Text("Default")
                                .font(AppFonts.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(AppColors.primary)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(AppColors.badgeBackground)
                                .clipShape(Capsule())
                        }
                    }

                    Text(address.streetAddress + (address.apartmentSuite.map { ", \($0)" } ?? ""))
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.textSecondary)

                    Text("\(address.city), \(address.state) \(address.zipCode)")
                        .font(AppFonts.footnote)
                        .foregroundColor(AppColors.textSecondary)

                    Text(address.phoneNumber)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textTertiary)
                }

                Spacer()

                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? AppColors.primary : AppColors.border)
            }
            .padding(AppSpacing.md)
            .background(AppColors.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .strokeBorder(
                        isSelected ? AppColors.primary : AppColors.border,
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }

    // MARK: - Confirm Bar

    private var confirmBar: some View {
        VStack(spacing: 0) {
            Divider()
            PrimaryButton(
                title: "Confirm Address",
                icon: "checkmark",
                isDisabled: cartVM.selectedAddressId == nil,
                style: .filled
            ) {
                if let id = cartVM.selectedAddressId,
                   let address = cartVM.addresses.first(where: { $0.id == id }) {
                    onConfirm(address)
                    dismiss()
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.background)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct CheckoutAddressView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutAddressView()
            .environmentObject(CartViewModel())
    }
}
#endif
