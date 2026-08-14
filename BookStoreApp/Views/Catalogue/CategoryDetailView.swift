//
// CategoryDetailView.swift
// BookstoreApp
//

import SwiftUI

/// Browseable category screen with category chip filter row,
/// horizontal publisher/brand scroller, sort picker, and adaptive book grid.
struct CategoryDetailView: View {
    @EnvironmentObject private var catalogueVM: CatalogueViewModel

    /// Pre-selected category when navigating from Home (optional).
    var initialCategory: Category? = nil

    var onBookTap: (Book) -> Void = { _ in }
    var onAddToCart: (Book) -> Void = { _ in }

    // Local sort state
    @State private var sortOption: SortOption = .relevance

    enum SortOption: String, CaseIterable, Identifiable {
        case relevance  = "Relevance"
        case priceLow   = "Price: Low–High"
        case priceHigh  = "Price: High–Low"
        case rating     = "Top Rated"
        var id: String { rawValue }
    }

    private var sortedBooks: [Book] {
        let base = catalogueVM.filteredBooks
        switch sortOption {
        case .relevance:  return base
        case .priceLow:   return base.sorted { $0.price < $1.price }
        case .priceHigh:  return base.sorted { $0.price > $1.price }
        case .rating:     return base.sorted { $0.rating > $1.rating }
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // ── Search bar row ──────────────────────────────────────
            searchBar
            Divider()

            ScrollView(showsIndicators: false) {
                LazyVStack(alignment: .leading, spacing: AppSpacing.lg) {

                    // Category chips
                    categoryChipRow
                        .padding(.top, AppSpacing.md)

                    // Publisher filter
                    publisherRow

                    // Sort + result count
                    sortRow
                        .padding(.horizontal, AppSpacing.md)

                    // Book grid
                    bookGrid
                        .padding(.horizontal, AppSpacing.md)
                        .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .background(AppColors.background)
        .navigationTitle(
            catalogueVM.selectedCategoryId
                .flatMap { id in catalogueVM.categories.first { $0.id == id }?.name }
                ?? "Browse"
        )
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .onAppear {
            if let cat = initialCategory {
                catalogueVM.selectCategory(cat.id)
            }
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: AppSpacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColors.textSecondary)
            TextField("Search books, authors…", text: $catalogueVM.searchText)
                .font(AppFonts.body)
            if !catalogueVM.searchText.isEmpty {
                Button {
                    catalogueVM.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColors.textTertiary)
                }
            }
        }
        .padding(AppSpacing.sm)
        .background(AppColors.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
    }

    // MARK: - Category Chips

    private var categoryChipRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: AppSpacing.sm) {
                // "All" chip
                PlainChip(
                    label: "All",
                    isSelected: catalogueVM.selectedCategoryId == nil
                ) {
                    catalogueVM.selectCategory(nil)
                }
                ForEach(catalogueVM.categories) { category in
                    CategoryChip(
                        category: category,
                        isSelected: catalogueVM.selectedCategoryId == category.id
                    ) {
                        catalogueVM.selectCategory(category.id)
                    }
                }
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.xs)
        }
    }

    // MARK: - Publisher Row

    private var publisherRow: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            SectionHeader(title: "Publishers")
                .padding(.horizontal, AppSpacing.md)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppSpacing.md) {
                    ForEach(catalogueVM.publishers) { publisher in
                        BrandCard(
                            brand: publisher,
                            isSelected: catalogueVM.selectedPublisherId == publisher.id
                        ) {
                            catalogueVM.selectPublisher(publisher.id)
                        }
                        .frame(width: 200)
                    }
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.xs)
            }
        }
    }

    // MARK: - Sort Row

    private var sortRow: some View {
        HStack {
            Text("\(sortedBooks.count) result\(sortedBooks.count == 1 ? "" : "s")")
                .font(AppFonts.footnote)
                .foregroundColor(AppColors.textSecondary)

            Spacer()

            Menu {
                Picker("Sort", selection: $sortOption) {
                    ForEach(SortOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
            } label: {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(size: 12, weight: .medium))
                    Text(sortOption.rawValue)
                        .font(AppFonts.footnote)
                        .fontWeight(.medium)
                }
                .foregroundColor(AppColors.primary)
            }
        }
    }

    // MARK: - Book Grid

    private var bookGrid: some View {
        GeometryReader { geo in
            LazyVGrid(
                columns: AppLayout.gridColumns(for: geo.size.width),
                spacing: AppSpacing.md
            ) {
                ForEach(sortedBooks) { book in
                    BookCard(book: book, mode: .grid, onAddToCart: {
                        onAddToCart(book)
                    }, onTap: {
                        onBookTap(book)
                    })
                }
            }
        }
        // GeometryReader collapses height — give it room via a fixed frame trick
        .frame(minHeight: CGFloat(max(1, sortedBooks.count)) * 280)
    }
}

// MARK: - Preview

#if DEBUG
struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CategoryDetailView()
                .environmentObject(CatalogueViewModel())
        }
    }
}
#endif
