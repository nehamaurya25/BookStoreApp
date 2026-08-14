//
// HomeCatalogueView.swift
// BookstoreApp
//

import SwiftUI

/// Main e-store landing page.
/// Sections: hero banner, category chips, featured carousel,
/// bestsellers grid, popular publishers row.
struct HomeCatalogueView: View {
    @EnvironmentObject private var catalogueVM: CatalogueViewModel
    @EnvironmentObject private var authVM: AuthViewModel

    let cartItemCount: Int
    let onCartTap: () -> Void
    var onBookTap: (Book) -> Void = { _ in }
    var onCategoryTap: (Category) -> Void = { _ in }
    var onAddToCart: (Book) -> Void = { _ in }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ── Top navigation bar ──────────────────────────────
                NavigationHeader(
                    cartItemCount: cartItemCount,
                    onSearchTap: {},
                    onCartTap: onCartTap
                )
                Divider()

                // ── Scrollable content ──────────────────────────────
                ScrollView(showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: AppSpacing.xl) {

                        // 1. Welcome greeting
                        greetingBanner
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.top, AppSpacing.md)

                        // 2. Hero promotional banner
                        heroBanner
                            .padding(.horizontal, AppSpacing.md)

                        // 3. Category chips
                        categorySection

                        // 4. Featured books horizontal carousel
                        featuredSection

                        // 5. Bestsellers grid
                        bestsellersSection

                        // 6. Popular publishers
                        publishersSection
                            .padding(.bottom, AppSpacing.xl)
                    }
                }
            }
            .navigationBarHidden(true)
            .background(AppColors.background)
        }
    }

    // MARK: - Greeting Banner

    private var greetingBanner: some View {
        HStack {
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(greetingText)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                Text(authVM.currentUser?.name ?? "Reader")
                    .font(AppFonts.title2)
                    .foregroundColor(AppColors.textPrimary)
            }
            Spacer()
            // Gift points badge
            if let user = authVM.currentUser {
                VStack(alignment: .trailing, spacing: AppSpacing.xxs) {
                    Text("\(user.giftPointsBalance) pts")
                        .font(AppFonts.badge)
                        .foregroundColor(AppColors.primary)
                    Text(user.memberTier)
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, AppSpacing.sm)
                .padding(.vertical, AppSpacing.xs)
                .background(AppColors.badgeBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
            }
        }
    }

    // MARK: - Hero Promo Banner

    private var heroBanner: some View {
        ZStack(alignment: .bottomLeading) {
            // Background gradient
            RoundedRectangle(cornerRadius: AppRadius.lg)
                .fill(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: AppLayout.heroBannerHeight)

            // Decorative circle
            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 180, height: 180)
                .offset(x: 200, y: -30)

            Circle()
                .fill(Color.white.opacity(0.04))
                .frame(width: 120, height: 120)
                .offset(x: 260, y: 40)

            // Content
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Members save up to")
                        .font(AppFonts.caption1)
                        .foregroundColor(Color.white.opacity(0.8))
                    Text("40% OFF")
                        .font(AppFonts.title1)
                        .foregroundColor(.white)
                    Text("On bestsellers this week")
                        .font(AppFonts.footnote)
                        .foregroundColor(Color.white.opacity(0.8))

                    Text("Shop Now")
                        .font(AppFonts.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primary)
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.vertical, AppSpacing.xs)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(AppSpacing.lg)

                Spacer()

                Image(systemName: "books.vertical.fill")
                    .font(.system(size: 72, weight: .thin))
                    .foregroundColor(Color.white.opacity(0.18))
                    .padding(.trailing, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.md)
            }
        }
    }

    // MARK: - Categories

    private var categorySection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Browse Categories")
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.sm) {
                    ForEach(catalogueVM.categories) { category in
                        CategoryChip(
                            category: category,
                            isSelected: catalogueVM.selectedCategoryId == category.id
                        ) {
                            onCategoryTap(category)
                            catalogueVM.selectCategory(category.id)
                        }
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    // MARK: - Featured Books

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(
                title: "Featured Books",
                subtitle: "Hand-picked for you",
                onSeeAll: {}
            )
            .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(catalogueVM.featuredBooks) { book in
                        BookCard(book: book, mode: .grid, onAddToCart: {
                            onAddToCart(book)
                        }, onTap: {
                            onBookTap(book)
                        })
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    // MARK: - Bestsellers

    private var bestsellersSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(
                title: "Bestsellers",
                subtitle: "Top-rated by our readers",
                onSeeAll: {}
            )
            .padding(.horizontal, AppSpacing.md)

            LazyVStack(spacing: AppSpacing.sm) {
                ForEach(catalogueVM.bestsellerBooks.prefix(4)) { book in
                    BookCard(book: book, mode: .horizontal, onAddToCart: {
                        onAddToCart(book)
                    }, onTap: {
                        onBookTap(book)
                    })
                    .padding(.horizontal, AppSpacing.md)
                }
            }
        }
    }

    // MARK: - Publishers

    private var publishersSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(
                title: "Popular Publishers",
                subtitle: "Trusted names in print"
            )
            .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(catalogueVM.publishers) { publisher in
                        publisherChip(publisher)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    private func publisherChip(_ publisher: BrandPublisher) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: publisher.logoIcon)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primary)
                .frame(width: 36, height: 36)
                .background(AppColors.badgeBackground)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            VStack(alignment: .leading, spacing: 2) {
                Text(publisher.name)
                    .font(AppFonts.caption1)
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(1)
                Text("\(publisher.titleCount) titles")
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textSecondary)
            }
        }
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.sm)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(AppShadow.cardOpacity),
                radius: AppShadow.cardRadius, x: 0, y: AppShadow.cardYOffset)
    }

    // MARK: - Helpers

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "Good morning,"
        case 12..<17: return "Good afternoon,"
        case 17..<21: return "Good evening,"
        default:      return "Good night,"
        }
    }
}

// MARK: - Preview

#if DEBUG
struct HomeCatalogueView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCatalogueView(cartItemCount: 2, onCartTap: {})
            .environmentObject(CatalogueViewModel())
            .environmentObject(AuthViewModel())
    }
}
#endif
