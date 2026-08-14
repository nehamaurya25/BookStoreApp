//
// Order.swift
// BookstoreApp
//

import Foundation

public enum OrderStatus: String, Codable, CaseIterable {
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    
    public var badgeColorHex: String {
        switch self {
        case .processing: return "#F59E0B" // Amber
        case .shipped: return "#3B82F6"    // Blue
        case .delivered: return "#10B981"  // Emerald
        case .cancelled: return "#EF4444"  // Red
        }
    }
}

public struct Order: Identifiable, Codable, Hashable {
    public let id: String
    public let orderNumber: String
    public let orderDate: Date
    public var status: OrderStatus
    public let items: [CartItem]
    public let shippingAddress: Address
    public let paymentMethodName: String
    public let subtotal: Double
    public let discountAmount: Double
    public let shippingFee: Double
    public let totalAmount: Double
    public let pointsEarned: Int
    public let pointsRedeemed: Int
    
    public init(
        id: String = UUID().uuidString,
        orderNumber: String,
        orderDate: Date,
        status: OrderStatus = .processing,
        items: [CartItem],
        shippingAddress: Address,
        paymentMethodName: String = "Credit Card (•••• 4242)",
        subtotal: Double,
        discountAmount: Double = 0.0,
        shippingFee: Double = 0.0,
        totalAmount: Double,
        pointsEarned: Int = 50,
        pointsRedeemed: Int = 0
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.orderDate = orderDate
        self.status = status
        self.items = items
        self.shippingAddress = shippingAddress
        self.paymentMethodName = paymentMethodName
        self.subtotal = subtotal
        self.discountAmount = discountAmount
        self.shippingFee = shippingFee
        self.totalAmount = totalAmount
        self.pointsEarned = pointsEarned
        self.pointsRedeemed = pointsRedeemed
    }
    
    /// Check if order is eligible for cancellation (must be placed within the last 48 hours and currently processing)
    public var canBeCancelled: Bool {
        guard status == .processing else { return false }
        let hoursSinceOrder = Date().timeIntervalSince(orderDate) / 3600.0
        return hoursSinceOrder <= 48.0
    }
    
    /// Remaining cancellation time in hours
    public var remainingCancelHours: Int {
        let hoursSinceOrder = Date().timeIntervalSince(orderDate) / 3600.0
        let remaining = 48.0 - hoursSinceOrder
        return max(0, Int(ceil(remaining)))
    }
    
    public var formattedOrderDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        return formatter.string(from: orderDate)
    }
    
    public var formattedTotal: String {
        return String(format: "$%.2f", totalAmount)
    }
}
