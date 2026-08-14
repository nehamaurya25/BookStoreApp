//
// CartViewModel.swift
// BookstoreApp
//

import SwiftUI
import Combine

public class CartViewModel: ObservableObject {
    @Published public var items: [CartItem] = []
    @Published public var isRedeemingPoints: Bool = false
    @Published public var addresses: [Address] = MockData.sampleAddresses
    @Published public var selectedAddressId: String? = MockData.sampleAddresses.first(where: { $0.isDefault })?.id

    // MARK: - Cart Operations

    public func addItem(_ book: Book, format: String? = nil) {
        let fmt = format ?? book.format
        if let idx = items.firstIndex(where: { $0.book.id == book.id && $0.selectedFormat == fmt }) {
            items[idx].quantity += 1
        } else {
            items.append(CartItem(book: book, quantity: 1, selectedFormat: fmt))
        }
    }

    public func removeItem(_ item: CartItem) {
        items.removeAll { $0.id == item.id }
    }

    public func updateQuantity(_ item: CartItem, quantity: Int) {
        guard quantity > 0 else { removeItem(item); return }
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].quantity = quantity
        }
    }

    public func clearCart() {
        items = []
        isRedeemingPoints = false
    }

    // MARK: - Pricing

    public var subtotal: Double {
        items.reduce(0) { $0 + $1.totalPrice }
    }

    public var shippingFee: Double {
        subtotal >= 35 ? 0 : 3.99
    }

    /// Dollar value of points discount when redemption is toggled on.
    public func pointsDiscount(for user: UserProfile?) -> Double {
        guard isRedeemingPoints, let user else { return 0 }
        // Cap discount at subtotal
        return min(user.giftPointsDollarValue, subtotal)
    }

    public func total(for user: UserProfile?) -> Double {
        max(0, subtotal + shippingFee - pointsDiscount(for: user))
    }

    public func formattedTotal(for user: UserProfile?) -> String {
        String(format: "$%.2f", total(for: user))
    }

    // MARK: - Recommendations
    // Suggest books from past order history that are not already in the cart.

    public func recommendations(from pastOrders: [Order]) -> [Book] {
        let cartBookIds = Set(items.map { $0.book.id })
        let orderedBooks = pastOrders
            .flatMap { $0.items.map { $0.book } }
        // Unique, preserving first-seen order, excluding what's already in cart
        var seen = Set<String>()
        return orderedBooks.filter {
            guard !cartBookIds.contains($0.id) else { return false }
            return seen.insert($0.id).inserted
        }
    }
}
