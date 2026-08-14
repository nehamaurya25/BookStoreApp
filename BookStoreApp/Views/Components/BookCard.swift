//
// BookCard.swift
// BookstoreApp
//

import SwiftUI

/// Display mode for BookCard: grid cell or horizontal carousel item.
enum BookCardMode {
    case grid
    case horizontal
}

/// Modern responsive book card supporting grid and horizontal list layout modes.
/// Displays cover art, badge tags (Bestseller / Featured / Sale), star rating, price, and a buy button.
struct BookCard: View {
    let book: Book
    var mode: BookCardMode = .grid
    let onAddToCart: () -> Void
    let onTap: () -> Void

    // Derived
    private var cardWidth: CGFloat {
        mode == .grid ? AppLayout.compactCardWidth : 160
    }

    private var coverHeight: CGFloat {
        cardWidth / AppLayout.coverAspectRatio
    }

    var body: some View {
        switch mode {
        case .grid:
            gridCard
        case .horizontal:
            horizontalCard
        }
    }

    // MARK: Grid Card

    private var gridCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Cover
            coverView
                .frame(width: cardWidth, height: coverHeight)

            // Info area
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                // Badge row
                badgeRow

                // Title
                Text(book.title)
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)

                // Author
                Text(book.author)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(1)

                // Stars
                starRow

                // Price + Buy button
                priceAndBuyRow
            }
            .padding(AppSpacing.sm)
        }
        .frame(width: cardWidth)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(AppShadow.cardOpacity),
                radius: AppShadow.cardRadius,
                x: 0, y: AppShadow.cardYOffset)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    // MARK: Horizontal Card

    private var horizontalCard: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            // Cover
            coverView
                .frame(width: 90, height: 90 / AppLayout.coverAspectRatio)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))

            // Info
            VStack(alignment: .leading, spacing: AppSpacing.xs) {
                badgeRow

                Text(book.title)
                    .font(AppFonts.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                    .lineLimit(2)

                Text(book.author)
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)

                starRow

                HStack {
                    priceLabel
                    Spacer()
                    addToCartButton
                }
            }

            Spacer(minLength: 0)
        }
        .padding(AppSpacing.md)
        .background(AppColors.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .shadow(color: .black.opacity(AppShadow.cardOpacity),
                radius: AppShadow.cardRadius,
                x: 0, y: AppShadow.cardYOffset)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }

    // MARK: Subviews

    private var coverView: some View {
        ZStack {
            Color(hex: book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                .opacity(0.3)

            Image(systemName: book.coverImageName)
                .font(.system(size: 44, weight: .light))
                .foregroundColor(Color(hex: book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))))
        }
        .clipShape(RoundedRectangle(cornerRadius: mode == .grid ? AppRadius.md : AppRadius.sm))
    }

    private var badgeRow: some View {
        HStack(spacing: AppSpacing.xs) {
            if book.isBestseller {
                BadgeTag(text: "Bestseller", colorHex: "5B3FD0")
            }
            if book.isFeatured {
                BadgeTag(text: "Featured", colorHex: "0EA5E9")
            }
            if book.originalPrice != nil {
                BadgeTag(text: "Sale", colorHex: "DC2626")
            }
        }
    }

    private var starRow: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Image(systemName: starIcon(for: index))
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.accent)
            }
            Text("(\(book.reviewCount))")
                .font(AppFonts.caption2)
                .foregroundColor(AppColors.textTertiary)
        }
    }

    private var priceAndBuyRow: some View {
        HStack(alignment: .center) {
            priceLabel
            Spacer()
            addToCartButton
        }
    }

    private var priceLabel: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(book.formattedPrice)
                .font(AppFonts.priceSmall)
                .foregroundColor(AppColors.textPrimary)
            if let orig = book.formattedOriginalPrice {
                Text(orig)
                    .font(AppFonts.caption2)
                    .foregroundColor(AppColors.textTertiary)
                    .strikethrough()
            }
        }
    }

    private var addToCartButton: some View {
        Button(action: onAddToCart) {
            Image(systemName: "plus")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 28, height: 28)
                .background(AppColors.primary)
                .clipShape(Circle())
        }
    }

    // MARK: Helpers

    private func starIcon(for index: Int) -> String {
        let filled = Int(book.rating.rounded())
        if index <= filled { return "star.fill" }
        let half = book.rating - Double(filled) >= 0.25
        if index == filled + 1 && half { return "star.leadinghalf.filled" }
        return "star"
    }
}

// MARK: - Badge Tag

/// Small inline badge used inside cards.
struct BadgeTag: View {
    let text: String
    let colorHex: String

    var body: some View {
        Text(text)
            .font(AppFonts.caption2)
            .fontWeight(.semibold)
            .foregroundColor(Color(hex: colorHex))
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(hex: colorHex).opacity(0.12))
            .clipShape(Capsule())
    }
}

// MARK: - Preview

#if DEBUG
struct BookCard_Previews: PreviewProvider {
    static let sampleBook = Book(
        id: "preview",
        title: "The Midnight Library",
        author: "Matt Haig",
        publisherId: "p1",
        publisherName: "Canongate",
        categoryId: "c1",
        categoryName: "Fiction",
        price: 14.99,
        originalPrice: 22.99,
        rating: 4.5,
        reviewCount: 8240,
        description: "A novel about regret and infinite possibility.",
        coverColorHex: "5B3FD0",
        isFeatured: true,
        isBestseller: true
    )

    static var previews: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                Text("Grid Mode").font(AppFonts.headline)
                BookCard(book: sampleBook, mode: .grid, onAddToCart: {}, onTap: {})

                Text("Horizontal Mode").font(AppFonts.headline)
                BookCard(book: sampleBook, mode: .horizontal, onAddToCart: {}, onTap: {})
                    .padding(.horizontal)
            }
            .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
