//
// LoginView.swift
// BookstoreApp
//

import SwiftUI

public struct LoginView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showPassword: Bool = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppSpacing.lg) {
                    
                    // Header Logo & Branding
                    VStack(spacing: AppSpacing.sm) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primary.opacity(0.12))
                                .frame(width: 80, height: 80)
                            
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(AppColors.primary)
                        }
                        
                        Text("Bookstore")
                            .font(AppFonts.largeTitle)
                            .foregroundColor(AppColors.textPrimary)
                        
                        Text(authVM.isSignUpMode ? "Create your reader account" : "Welcome back, book lover!")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    .padding(.top, AppSpacing.xl)
                    
                    // Input Form Card
                    VStack(spacing: AppSpacing.md) {
                        
                        if authVM.isSignUpMode {
                            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                Text("Full Name")
                                    .font(AppFonts.caption1)
                                    .foregroundColor(AppColors.textSecondary)
                                
                                HStack {
                                    Image(systemName: "person.fill")
                                        .foregroundColor(AppColors.textSecondary)
                                    TextField("Alex Morgan", text: $authVM.nameInput)
                                        .autocapitalization(.words)
                                }
                                .padding()
                                .background(AppColors.secondaryBackground)
                                .cornerRadius(AppRadius.md)
                            }
                        }
                        
                        // Email Field
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Email Address")
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                TextField("alex@example.com", text: $authVM.emailInput)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding()
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(AppRadius.md)
                        }
                        
                        // Password Field
                        VStack(alignment: .leading, spacing: AppSpacing.xs) {
                            Text("Password")
                                .font(AppFonts.caption1)
                                .foregroundColor(AppColors.textSecondary)
                            
                            HStack {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(AppColors.textSecondary)
                                
                                if showPassword {
                                    TextField("Password", text: $authVM.passwordInput)
                                } else {
                                    SecureField("Password", text: $authVM.passwordInput)
                                }
                                
                                Button {
                                    showPassword.toggle()
                                } label: {
                                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                        .foregroundColor(AppColors.textSecondary)
                                }
                            }
                            .padding()
                            .background(AppColors.secondaryBackground)
                            .cornerRadius(AppRadius.md)
                        }
                        
                        // Error message
                        if let error = authVM.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                Text(error)
                            }
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        // Action Button
                        PrimaryButton(
                            title: authVM.isSignUpMode ? "Create Account" : "Sign In",
                            icon: "arrow.right",
                            isLoading: authVM.isLoading
                        ) {
                            if authVM.isSignUpMode {
                                authVM.signUp()
                            } else {
                                authVM.login()
                            }
                        }
                        .padding(.top, AppSpacing.sm)
                        
                        // Demo Shortcut
                        Button {
                            authVM.emailInput = "alex.morgan@example.com"
                            authVM.passwordInput = "password123"
                            authVM.login()
                        } label: {
                            HStack {
                                Image(systemName: "bolt.fill")
                                Text("Fill Demo Credentials & Login")
                            }
                            .font(AppFonts.footnote)
                            .foregroundColor(AppColors.accent)
                        }
                        .padding(.top, AppSpacing.xs)
                    }
                    .padding(AppSpacing.lg)
                    .background(AppColors.surface)
                    .cornerRadius(AppRadius.lg)
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.lg)
                            .stroke(AppColors.border, lineWidth: 1)
                    )
                    
                    // Toggle Auth Mode
                    HStack {
                        Text(authVM.isSignUpMode ? "Already have an account?" : "Don't have an account?")
                            .font(AppFonts.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                        
                        Button {
                            withAnimation {
                                authVM.isSignUpMode.toggle()
                                authVM.errorMessage = nil
                            }
                        } label: {
                            Text(authVM.isSignUpMode ? "Sign In" : "Sign Up")
                                .font(AppFonts.headline)
                                .foregroundColor(AppColors.primary)
                        }
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.md)
            }
            .background(AppColors.background.ignoresSafeArea())
            .navigationTitle(authVM.isSignUpMode ? "Sign Up" : "Sign In")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
        }
    }
}
