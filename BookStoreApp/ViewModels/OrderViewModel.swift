//
// OrderViewModel.swift
// BookstoreApp
//

import SwiftUI
import Combine

public class OrderViewModel: ObservableObject {
    @Published public var orders: [Order] = MockData.sampleOrders
    @Published public var selectedOrder: Order? = nil

    public init() {}

    // MARK: - Order Creation

    /// Creates a new order from the current cart and appends it to history.
    public func placeOrder(
        from cartItems: [CartItem],
        address: Address,
        paymentMethod: String,
        subtotal: Double,
        discount: Double,
        shipping: Double,
        total: Double,
        pointsRedeemed: Int
    ) -> Order {
        let order = Order(
            id: "ord_\(UUID().uuidString.prefix(6))",
            orderNumber: "BK-\(Int.random(in: 100000...999999))",
            orderDate: Date(),
            status: .processing,
            items: cartItems,
            shippingAddress: address,
            paymentMethodName: paymentMethod,
            subtotal: subtotal,
            discountAmount: discount,
            shippingFee: shipping,
            totalAmount: total,
            pointsEarned: max(1, Int(total)),
            pointsRedeemed: pointsRedeemed
        )
        orders.insert(order, at: 0)
        return order
    }

    // MARK: - Cancellation

    public func cancelOrder(_ order: Order) {
        guard order.canBeCancelled,
              let idx = orders.firstIndex(where: { $0.id == order.id }) else { return }
        orders[idx].status = .cancelled
        if selectedOrder?.id == order.id {
            selectedOrder = orders[idx]
        }
    }

    // MARK: - Buy Again

    /// Returns the cart items from a past order ready to be re-added to the cart.
    public func buyAgainItems(for order: Order) -> [CartItem] {
        order.items.map { CartItem(book: $0.book, quantity: $0.quantity, selectedFormat: $0.selectedFormat) }
    }
}
