//
// Book.swift
// BookstoreApp
//

import Foundation

public struct Book: Identifiable, Codable, Hashable {
    public let id: String
    public let title: String
    public let author: String
    public let publisherId: String
    public let publisherName: String
    public let categoryId: String
    public let categoryName: String
    public let price: Double
    public let originalPrice: Double?
    public let rating: Double
    public let reviewCount: Int
    public let format: String // Hardcover, Paperback, E-Book, Audiobook
    public let pageCount: Int
    public let isbn: String
    public let description: String
    public let coverImageName: String
    public let coverColorHex: String
    public let estimatedDeliveryDays: Int
    public let isFeatured: Bool
    public let isBestseller: Bool
    public let stockCount: Int
    public let relatedBookIds: [String]
    
    public init(
        id: String,
        title: String,
        author: String,
        publisherId: String,
        publisherName: String,
        categoryId: String,
        categoryName: String,
        price: Double,
        originalPrice: Double? = nil,
        rating: Double,
        reviewCount: Int,
        format: String = "Paperback",
        pageCount: Int = 320,
        isbn: String = "978-0123456789",
        description: String,
        coverImageName: String = "book.closed.fill",
        coverColorHex: String = "#3B82F6",
        estimatedDeliveryDays: Int = 3,
        isFeatured: Bool = false,
        isBestseller: Bool = false,
        stockCount: Int = 25,
        relatedBookIds: [String] = []
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.publisherId = publisherId
        self.publisherName = publisherName
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.price = price
        self.originalPrice = originalPrice
        self.rating = rating
        self.reviewCount = reviewCount
        self.format = format
        self.pageCount = pageCount
        self.isbn = isbn
        self.description = description
        self.coverImageName = coverImageName
        self.coverColorHex = coverColorHex
        self.estimatedDeliveryDays = estimatedDeliveryDays
        self.isFeatured = isFeatured
        self.isBestseller = isBestseller
        self.stockCount = stockCount
        self.relatedBookIds = relatedBookIds
    }
    
    public var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    public var formattedOriginalPrice: String? {
        guard let orig = originalPrice else { return nil }
        return String(format: "$%.2f", orig)
    }
    
    public var tentativeDeliveryDateString: String {
        let calendar = Calendar.current
        if let targetDate = calendar.date(byAdding: .day, value: estimatedDeliveryDays, to: Date()) {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d"
            return formatter.string(from: targetDate)
        }
        return "2-3 business days"
    }
}
