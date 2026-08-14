//
// ContentView.swift
// BookstoreApp
//

import SwiftUI

/// Root navigation shell with a 4-tab bar:
///  1. Home / Catalogue
///  2. Search & Categories
///  3. Shopping Cart
///  4. My Orders & Profile
struct ContentView: View {
    @EnvironmentObject private var authVM: AuthViewModel
    @StateObject private var catalogueVM = CatalogueViewModel()
    @StateObject private var cartVM = CartViewModel()
    @StateObject private var orderVM = OrderViewModel()

    @State private var selectedTab: AppTab = .home
    @State private var selectedBook: Book? = nil
    @State private var selectedOrder: Order? = nil
    @State private var showAddressSheet: Bool = false
    @State private var confirmedAddress: Address? = nil

    /// Derived from cartVM so the tab badge stays in sync.
    private var cartItemCount: Int { cartVM.items.reduce(0) { $0 + $1.quantity } }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Tab 1 – Home / Catalogue
            NavigationStack {
                if #available(iOS 17.0, *) {
                    HomeCatalogueView(
                        cartItemCount: cartItemCount,
                        onCartTap: { selectedTab = .cart },
                        onBookTap: { selectedBook = $0 },
                        onCategoryTap: { _ in selectedTab = .search },
                        onAddToCart: { cartVM.addItem($0) }
                    )
                    .environmentObject(catalogueVM)
                    .navigationDestination(item: $selectedBook) { book in
                        BookDetailView(book: book, onAddToCart: { b, fmt in cartVM.addItem(b, format: fmt) })
                            .environmentObject(catalogueVM)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem { Label("Home", systemImage: "house.fill") }
            .tag(AppTab.home)

            // Tab 2 – Search & Categories
            NavigationStack {
                if #available(iOS 17.0, *) {
                    CategoryDetailView(
                        onBookTap: { selectedBook = $0 },
                        onAddToCart: { cartVM.addItem($0) }
                    )
                    .environmentObject(catalogueVM)
                    .navigationDestination(item: $selectedBook) { book in
                        BookDetailView(book: book, onAddToCart: { b, fmt in cartVM.addItem(b, format: fmt) })
                            .environmentObject(catalogueVM)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem { Label("Search", systemImage: "magnifyingglass") }
            .tag(AppTab.search)

            // Tab 3 – Shopping Cart
            NavigationStack {
                if #available(iOS 17.0, *) {
                    ShoppingCartView(
                        pastOrders: orderVM.orders,
                        onCheckout: { showAddressSheet = true },
                        onBookTap: { selectedBook = $0 }
                    )
                    .environmentObject(cartVM)
                    .environmentObject(authVM)
                    // Address sheet → payment push
                    .sheet(isPresented: $showAddressSheet) {
                        CheckoutAddressView(onConfirm: { addr in
                            confirmedAddress = addr
                            showAddressSheet = false
                        })
                        .environmentObject(cartVM)
                    }
                    .navigationDestination(item: $confirmedAddress) { address in
                        PaymentScreen(
                            selectedAddress: address,
                            onPaymentComplete: { order in
                                selectedOrder = order
                                selectedTab = .orders
                            }
                        )
                        .environmentObject(cartVM)
                        .environmentObject(authVM)
                        .environmentObject(orderVM)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem { Label("Cart", systemImage: "bag.fill") }
            .badge(cartItemCount > 0 ? cartItemCount : 0)
            .tag(AppTab.cart)

            // Tab 4 – My Orders
            NavigationStack {
                if #available(iOS 17.0, *) {
                    OrderHistoryView(onOrderTap: { selectedOrder = $0 })
                        .environmentObject(orderVM)
                        .environmentObject(cartVM)
                        .navigationDestination(item: $selectedOrder) { order in
                            OrderDetailView(order: order)
                                .environmentObject(orderVM)
                                .environmentObject(cartVM)
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            .tabItem { Label("Orders", systemImage: "clock.fill") }
            .tag(AppTab.orders)
        }
        .tint(AppColors.primary)
    }
}

// MARK: - Tab Enum

enum AppTab: Hashable {
    case home, search, cart, orders
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
#endif
