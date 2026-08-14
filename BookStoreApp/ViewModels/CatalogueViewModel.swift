//
// CatalogueViewModel.swift
// BookstoreApp
//

import SwiftUI
import Combine

public class CatalogueViewModel: ObservableObject {
    @Published public var books: [Book] = MockData.sampleBooks
    @Published public var categories: [Category] = MockData.sampleCategories
    @Published public var publishers: [BrandPublisher] = MockData.samplePublishers
    
    @Published public var searchText: String = ""
    @Published public var selectedCategoryId: String? = nil
    @Published public var selectedPublisherId: String? = nil
    @Published public var selectedBookForDetail: Book? = nil
    
    public init() {}
    
    public var featuredBooks: [Book] {
        books.filter { $0.isFeatured }
    }
    
    public var bestsellerBooks: [Book] {
        books.filter { $0.isBestseller }
    }
    
    public var filteredBooks: [Book] {
        books.filter { book in
            let matchesSearch = searchText.isEmpty ||
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText) ||
                book.categoryName.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategoryId == nil || book.categoryId == selectedCategoryId
            let matchesPublisher = selectedPublisherId == nil || book.publisherId == selectedPublisherId
            
            return matchesSearch && matchesCategory && matchesPublisher
        }
    }
    
    public func getRelatedBooks(for book: Book) -> [Book] {
        let related = books.filter { book.relatedBookIds.contains($0.id) }
        if !related.isEmpty {
            return related
        }
        // Fallback: same category
        return books.filter { $0.categoryId == book.categoryId && $0.id != book.id }
    }
    
    public func selectCategory(_ id: String?) {
        if selectedCategoryId == id {
            selectedCategoryId = nil
        } else {
            selectedCategoryId = id
        }
    }
    
    public func selectPublisher(_ id: String?) {
        if selectedPublisherId == id {
            selectedPublisherId = nil
        } else {
            selectedPublisherId = id
        }
    }
}
