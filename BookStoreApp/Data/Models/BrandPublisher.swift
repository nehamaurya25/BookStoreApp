//
// BrandPublisher.swift
// BookstoreApp
//

import Foundation

public struct BrandPublisher: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let logoIcon: String
    public let country: String
    public let foundedYear: Int
    public let titleCount: Int
    public let isPopular: Bool
    
    public init(
        id: String,
        name: String,
        logoIcon: String = "building.columns.fill",
        country: String = "United States",
        foundedYear: Int = 1925,
        titleCount: Int = 1500,
        isPopular: Bool = true
    ) {
        self.id = id
        self.name = name
        self.logoIcon = logoIcon
        self.country = country
        self.foundedYear = foundedYear
        self.titleCount = titleCount
        self.isPopular = isPopular
    }
}
