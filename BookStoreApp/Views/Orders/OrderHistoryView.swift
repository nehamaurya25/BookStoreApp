//
// OrderHistoryView.swift
// BookstoreApp
//

import SwiftUI

/// Full order history list with "Buy Again" and 48-hour cancellation support.
struct OrderHistoryView: View {
    @EnvironmentObject private var orderVM: OrderViewModel
    @EnvironmentObject private var cartVM: CartViewModel

    var onOrderTap: (Order) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            Group {
                if orderVM.orders.isEmpty {
                    emptyState
                } else {
                    orderList
                }
            }
            .navigationTitle("My Orders")
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
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 64, weight: .thin))
                .foregroundColor(AppColors.textTertiary)
            Text("No orders yet")
                .font(AppFonts.title3)
                .foregroundColor(AppColors.textPrimary)
            Text("Your completed orders will appear here.")
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            Spacer()
        }
    }

    // MARK: - Order List

    private var orderList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: AppSpacing.md) {
                ForEach(orderVM.orders) { order in
                    OrderRowView(
                        order: order,
                        onBuyAgain: {
                            let items = orderVM.buyAgainItems(for: order)
                            items.forEach { cartVM.addItem($0.book, format: $0.selectedFormat) }
                        },
                        onCancel: {
                            orderVM.cancelOrder(order)
                        },
                        onTap: { onOrderTap(order) }
                    )
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .padding(.vertical, AppSpacing.md)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
            .environmentObject(OrderViewModel())
            .environmentObject(CartViewModel())
    }
}
#endif
