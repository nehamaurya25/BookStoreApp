//
// CartItem.swift
// BookstoreApp
//

import Foundation

public struct CartItem: Identifiable, Codable, Hashable {
    public var id: String { "\(book.id)-\(selectedFormat)" }
    public let book: Book
    public var quantity: Int
    public var selectedFormat: String
    
    public init(book: Book, quantity: Int = 1, selectedFormat: String? = nil) {
        self.book = book
        self.quantity = quantity
        self.selectedFormat = selectedFormat ?? book.format
    }
    
    public var totalPrice: Double {
        return book.price * Double(quantity)
    }
    
    public var formattedTotalPrice: String {
        return String(format: "$%.2f", totalPrice)
    }
}
