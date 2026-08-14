//
// NavigationHeader.swift
// BookstoreApp
//

import SwiftUI

/// Top navigation bar with app logo/title, cart badge count button, and search trigger.
struct NavigationHeader: View {
    let cartItemCount: Int
    let onSearchTap: () -> Void
    let onCartTap: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            // App logo + title
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(AppColors.primary)
                Text("Bookstore")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            }

            Spacer()

            // Search button
            Button(action: onSearchTap) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppColors.textPrimary)
                    .frame(width: 40, height: 40)
            }

            // Cart button with badge
            Button(action: onCartTap) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: "bag")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.textPrimary)
                        .frame(width: 40, height: 40)

                    if cartItemCount > 0 {
                        Text(cartItemCount > 99 ? "99+" : "\(cartItemCount)")
                            .font(AppFonts.caption2)
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(AppColors.primary)
                            .clipShape(Capsule())
                            .offset(x: 6, y: -4)
                    }
                }
            }
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.background)
    }
}

// MARK: - Preview

#if DEBUG
struct NavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            NavigationHeader(cartItemCount: 3, onSearchTap: {}, onCartTap: {})
            NavigationHeader(cartItemCount: 0, onSearchTap: {}, onCartTap: {})
            NavigationHeader(cartItemCount: 100, onSearchTap: {}, onCartTap: {})
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
