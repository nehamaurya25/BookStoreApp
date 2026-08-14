//
// Category.swift
// BookstoreApp
//

import Foundation

public struct Category: Identifiable, Codable, Hashable {
    public let id: String
    public let name: String
    public let systemIcon: String
    public let description: String
    public let bookCount: Int
    
    public init(id: String, name: String, systemIcon: String, description: String, bookCount: Int = 0) {
        self.id = id
        self.name = name
        self.systemIcon = systemIcon
        self.description = description
        self.bookCount = bookCount
    }
}
