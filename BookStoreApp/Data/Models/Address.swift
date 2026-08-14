//
// Address.swift
// BookstoreApp
//

import Foundation

public struct Address: Identifiable, Codable, Hashable {
    public let id: String
    public let recipientName: String
    public let streetAddress: String
    public let apartmentSuite: String?
    public let city: String
    public let state: String
    public let zipCode: String
    public let country: String
    public let phoneNumber: String
    public var isDefault: Bool
    
    public init(
        id: String = UUID().uuidString,
        recipientName: String,
        streetAddress: String,
        apartmentSuite: String? = nil,
        city: String,
        state: String,
        zipCode: String,
        country: String = "United States",
        phoneNumber: String,
        isDefault: Bool = false
    ) {
        self.id = id
        self.recipientName = recipientName
        self.streetAddress = streetAddress
        self.apartmentSuite = apartmentSuite
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.phoneNumber = phoneNumber
        self.isDefault = isDefault
    }
    
    public var singleLineFormat: String {
        let aptStr = apartmentSuite.map { ", \($0)" } ?? ""
        return "\(streetAddress)\(aptStr), \(city), \(state) \(zipCode)"
    }
}
