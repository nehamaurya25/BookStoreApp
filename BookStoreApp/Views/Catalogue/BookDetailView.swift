//
// BookDetailView.swift
// BookstoreApp
//

import SwiftUI

/// Full product detail screen.
/// Shows cover art, metadata, tentative delivery badge, format picker,
/// stock status, description, and a related books carousel.
struct BookDetailView: View {
    @EnvironmentObject private var catalogueVM: CatalogueViewModel

    let book: Book
    var onAddToCart: (Book, String) -> Void = { _, _ in }

    @State private var selectedFormat: String = ""
    @State private var addedToCart: Bool = false
    @Environment(\.dismiss) private var dismiss

    private let availableFormats = ["Hardcover", "Paperback", "E-Book"]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Hero cover ───────────────────────────────────────
                heroCover

                // ── Content ─────────────────────────────────────────
                VStack(alignment: .leading, spacing: AppSpacing.lg) {

                    // Title block
                    titleBlock

                    Divider()

                    // Delivery + stock row
                    deliveryStockRow

                    Divider()

                    // Format picker
                    formatPicker

                    Divider()

                    // Description
                    descriptionBlock

                    // Related books
                    relatedSection

                        .padding(.bottom, AppSpacing.xl)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, AppSpacing.lg)
            }
        }
        .background(AppColors.background)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .safeAreaInset(edge: .bottom) {
            addToCartBar
        }
        .onAppear {
            selectedFormat = book.format
        }
    }

    // MARK: - Hero Cover

    private var heroCover: some View {
        ZStack {
            // Full-width tinted background
            Color(hex: book.coverColorHex.trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                .opacity(0.18)
                .frame(maxWidth: .infinity)
                .frame(height: 280)

            VStack(spacing: AppSpacing.md) {
                // Cover card
                ZStack {
                    RoundedRectangle(cornerRadius: AppRadius.lg)
                        .fill(
                            Color(hex: book.coverColorHex
                                .trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                            .opacity(0.25)
                        )
                        .frame(width: 140, height: 140 / AppLayout.coverAspectRatio)

                    Image(systemName: book.coverImageName)
                        .font(.system(size: 60, weight: .thin))
                        .foregroundColor(
                            Color(hex: book.coverColorHex
                                .trimmingCharacters(in: CharacterSet(charactersIn: "#")))
                        )
                }
                .shadow(color: .black.opacity(0.14), radius: 16, x: 0, y: 8)
            }
        }
    }

    // MARK: - Title Block

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xs) {
            // Badges
            HStack(spacing: AppSpacing.xs) {
                if book.isBestseller { BadgeTag(text: "Bestseller", colorHex: "5B3FD0") }
                if book.isFeatured   { BadgeTag(text: "Featured",   colorHex: "0EA5E9") }
                if book.originalPrice != nil { BadgeTag(text: "Sale", colorHex: "DC2626") }
                BadgeTag(text: book.categoryName, colorHex: "059669")
            }

            Text(book.title)
                .font(AppFonts.title2)
                .foregroundColor(AppColors.textPrimary)

            Text("by \(book.author)")
                .font(AppFonts.subheadline)
                .foregroundColor(AppColors.textSecondary)

            Text(book.publisherName)
                .font(AppFonts.caption1)
                .foregroundColor(AppColors.textTertiary)

            // Rating row
            HStack(spacing: AppSpacing.xs) {
                starRow
                Text(String(format: "%.1f", book.rating))
                    .font(AppFonts.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(AppColors.textPrimary)
                Text("(\(book.reviewCount) reviews)")
                    .font(AppFonts.caption1)
                    .foregroundColor(AppColors.textSecondary)
            }

            // Price
            HStack(alignment: .firstTextBaseline, spacing: AppSpacing.sm) {
                Text(book.formattedPrice)
                    .font(AppFonts.price)
                    .foregroundColor(AppColors.textPrimary)
                if let orig = book.formattedOriginalPrice {
                    Text(orig)
                        .font(AppFonts.subheadline)
                        .foregroundColor(AppColors.textTertiary)
                        .strikethrough()
                }
            }
        }
    }

    // MARK: - Delivery & Stock

    private var deliveryStockRow: some View {
        HStack(spacing: AppSpacing.lg) {
            // Delivery badge
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: "shippingbox.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.success)
                VStack(alignment: .leading, spacing: 1) {
                    Text("Delivers by")
                        .font(AppFonts.caption2)
                        .foregroundColor(AppColors.textSecondary)
                    Text(book.tentativeDeliveryDateString)
                        .font(AppFonts.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.success)
                }
            }

            Divider().frame(height: 32)

            // Stock badge
            HStack(spacing: AppSpacing.xs) {
                Image(systemName: book.stockCount > 0 ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(book.stockCount > 0 ? AppColors.success : AppColors.error)
                VStack(alignment: .leading, spacing: 1) {
                    Text(book.stockCount > 0 ? "In Stock" : "Out of Stock")
                        .font(AppFonts.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(book.stockCount > 0 ? AppColors.success : AppColors.error)
                    if book.stockCount > 0 && book.stockCount < 10 {
                        Text("Only \(book.stockCount) left")
                            .font(AppFonts.caption2)
                            .foregroundColor(AppColors.warning)
                    }
                }
            }

            Spacer()
        }
    }

    // MARK: - Format Picker

    private var formatPicker: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Format")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)

            HStack(spacing: AppSpacing.sm) {
                ForEach(availableFormats, id: \.self) { format in
                    Button {
                        selectedFormat = format
                    } label: {
                        Text(format)
                            .font(AppFonts.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selectedFormat == format ? .white : AppColors.textPrimary)
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, AppSpacing.sm)
                            .background(selectedFormat == format ? AppColors.primary : AppColors.secondaryBackground)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.sm)
                                    .strokeBorder(
                                        selectedFormat == format ? Color.clear : AppColors.border,
                                        lineWidth: 1
                                    )
                            )
                    }
                    .animation(.easeInOut(duration: 0.15), value: selectedFormat)
                }
            }
        }
    }

    // MARK: - Description

    private var descriptionBlock: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("About this book")
                .font(AppFonts.headline)
                .foregroundColor(AppColors.textPrimary)
            Text(book.description)
                .font(AppFonts.body)
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(4)

            // Metadata chips
            HStack(spacing: AppSpacing.sm) {
                metaChip(icon: "doc.text", label: "\(book.pageCount) pages")
                metaChip(icon: "barcode", label: book.isbn)
            }
        }
    }

    private func metaChip(icon: String, label: String) -> some View {
        HStack(spacing: AppSpacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 11))
            Text(label)
                .font(AppFonts.caption1)
        }
        .foregroundColor(AppColors.textSecondary)
        .padding(.horizontal, AppSpacing.sm)
        .padding(.vertical, AppSpacing.xs)
        .background(AppColors.secondaryBackground)
        .clipShape(Capsule())
    }

    // MARK: - Related Books

    private var relatedSection: some View {
        let related = catalogueVM.getRelatedBooks(for: book)
        return VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "You May Also Like")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(related) { related in
                        BookCard(book: related, mode: .grid, onAddToCart: {
                            onAddToCart(related, related.format)
                        }, onTap: {
                            // Navigate handled by parent
                            catalogueVM.selectedBookForDetail = related
                        })
                    }
                }
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    // MARK: - Add to Cart Bar

    private var addToCartBar: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: AppSpacing.md) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(book.formattedPrice)
                        .font(AppFonts.price)
                        .foregroundColor(AppColors.textPrimary)
                    Text(selectedFormat)
                        .font(AppFonts.caption1)
                        .foregroundColor(AppColors.textSecondary)
                }

                PrimaryButton(
                    title: addedToCart ? "Added!" : "Add to Basket",
                    icon: addedToCart ? "checkmark" : "bag.badge.plus",
                    isDisabled: book.stockCount == 0,
                    style: .filled
                ) {
                    guard !addedToCart else { return }
                    onAddToCart(book, selectedFormat)
                    withAnimation(.easeInOut(duration: 0.2)) { addedToCart = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { addedToCart = false }
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.md)
            .background(AppColors.background)
        }
    }

    // MARK: - Helpers

    private var starRow: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                let filled = Int(book.rating.rounded())
                let isHalf = index == filled + 1 && book.rating - Double(filled) >= 0.25
                Image(systemName: index <= filled ? "star.fill" : (isHalf ? "star.leadinghalf.filled" : "star"))
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.accent)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BookDetailView(book: MockData.sampleBooks[0])
                .environmentObject(CatalogueViewModel())
        }
    }
}
#endif
