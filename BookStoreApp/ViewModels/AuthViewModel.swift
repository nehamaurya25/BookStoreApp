//
// AuthViewModel.swift
// BookstoreApp
//

import SwiftUI
import Combine

public class AuthViewModel: ObservableObject {
    @Published public var currentUser: UserProfile?
    @Published public var isAuthenticated: Bool = false
    @Published public var emailInput: String = "alex.morgan@example.com"
    @Published public var passwordInput: String = "password123"
    @Published public var errorMessage: String? = nil
    @Published public var isLoading: Bool = false
    @Published public var isSignUpMode: Bool = false
    @Published public var nameInput: String = ""
    
    public init() {
        // Pre-authenticate with sample user for seamless testing
        self.currentUser = MockData.sampleUser
        self.isAuthenticated = true
    }
    
    public func login() {
        guard !emailInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your email address."
            return
        }
        guard !passwordInput.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate net delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isLoading = false
            self.currentUser = UserProfile(
                id: "usr_\(UUID().uuidString.prefix(6))",
                name: self.nameInput.isEmpty ? "Alex Morgan" : self.nameInput,
                email: self.emailInput,
                avatarImageName: "person.crop.circle.fill",
                giftPointsBalance: 420,
                memberTier: "Gold Reader",
                defaultAddressId: MockData.sampleAddresses.first?.id
            )
            self.isAuthenticated = true
        }
    }
    
    public func signUp() {
        guard !nameInput.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter your full name."
            return
        }
        login()
    }
    
    public func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
    }
    
    public func redeemGiftPoints(_ points: Int) {
        guard var user = currentUser, user.giftPointsBalance >= points else { return }
        user.giftPointsBalance -= points
        self.currentUser = user
    }
}
