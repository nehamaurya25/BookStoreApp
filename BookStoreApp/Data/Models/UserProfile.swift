//
// UserProfile.swift
// BookstoreApp
//

import Foundation

public struct UserProfile: Identifiable, Codable, Hashable {
    public let id: String
    public var name: String
    public var email: String
    public var avatarImageName: String
    public var giftPointsBalance: Int
    public var memberTier: String
    public var defaultAddressId: String?
    
    public init(
        id: String,
        name: String,
        email: String,
        avatarImageName: String = "person.crop.circle.fill",
        giftPointsBalance: Int = 350,
        memberTier: String = "Gold Reader",
        defaultAddressId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarImageName = avatarImageName
        self.giftPointsBalance = giftPointsBalance
        self.memberTier = memberTier
        self.defaultAddressId = defaultAddressId
    }
    
    public var giftPointsDollarValue: Double {
        return Double(giftPointsBalance) * 0.05 // 100 points = $5.00
    }
    
    public var formattedGiftPointsValue: String {
        return String(format: "$%.2f", giftPointsDollarValue)
    }
}
