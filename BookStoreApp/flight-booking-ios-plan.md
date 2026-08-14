# Implementation Plan - E-Bookstore SwiftUI Mobile App (`BookstoreApp`)

A responsive iOS mobile application built with SwiftUI and Swift following clean MVVM architecture, modular UI design system, reusable card and navbar components, adaptive layouts, and complete end-to-end user journeys for an online Bookstore platform.

## Architecture & Project Structure Overview

The project will reside in a standalone `BookstoreApp/` directory alongside `FlightBookingApp/` in the workspace repository.

```
BookstoreApp/
├── BookstoreApp.swift                   # Main App entry point (@main) with Environment Objects
├── ContentView.swift                    # Root TabView Navigation Shell (Catalogue, Search/Categories, Orders, Cart, Profile)
├── Package.swift                        # SPM Package manifest
├── README.md                            # Documentation and Xcode project instructions
├── Theme/
│   ├── Colors.swift                     # Bookstore Theme Colors (Primary, Accent, Backgrounds, Badges)
│   ├── Typography.swift                 # Font hierarchy, Spacing, and Corner Radii
│   └── Layout.swift                     # Responsive layout helpers (Grid columns, Adaptive sizing)
├── Data/
│   └── Models/
│       ├── Book.swift                   # Book model (ID, Title, Author, Price, Rating, Image, Category, DeliveryDate, IsInStock, RelatedIDs)
│       ├── Category.swift               # Category model (ID, Name, Icon, Description)
│       ├── BrandPublisher.swift         # Brand / Publisher model (ID, Name, Logo, Country)
│       ├── CartItem.swift               # Cart item model (Book, Quantity, SelectedFormat)
│       ├── Order.swift                  # Order model (ID, Date, Status, Items, DeliveryAddress, PaymentMethod, TotalAmount, CanCancel)
│       ├── Address.swift                # Shipping Address model (ID, Recipient, Street, City, Zip, IsDefault)
│       └── UserProfile.swift            # User Profile model (Name, Email, GiftPoints, RewardBalance)
├── ViewModels/
│   ├── AuthViewModel.swift              # Authentication state management (Login, Register, Logout)
│   ├── CatalogueViewModel.swift         # Catalogue browsing, searching, category filtering, brand selection
│   ├── CartViewModel.swift              # Shopping cart operations, gift point redemption, recommendations
│   └── OrderViewModel.swift             # Order history, order cancellation (< 48 hrs), "Buy In Again" logic
├── Views/
│   ├── Components/
│   │   ├── NavigationHeader.swift       # Reusable top navigation bar with cart badge & search
│   │   ├── BookCard.swift               # Grid & horizontal carousel book card with cover & price
│   │   ├── CategoryChip.swift           # Scrollable category filter pill
│   │   ├── BrandCard.swift              # Brand/Publisher selection card
│   │   ├── PrimaryButton.swift          # Modern custom styled action button
│   │   ├── SectionHeader.swift          # Section title with "See All" action
│   │   └── OrderRowView.swift           # Order summary row with "Buy In Again" button
│   ├── Auth/
│   │   └── LoginView.swift              # Login / Signup screen with authentication toggle
│   ├── Catalogue/
│   │   ├── HomeCatalogueView.swift      # Main E-store landing page with banners, categories, featured books
│   │   ├── CategoryDetailView.swift     # Products filtered by category & brand filtering
│   │   └── BookDetailView.swift         # Product detail page, tentative delivery date, related products
│   ├── Cart/
│   │   ├── ShoppingCartView.swift       # Cart items, points redemption, recommendation carousel based on history
│   │   └── CheckoutAddressView.swift    # Delivery address selection & management
│   ├── Payment/
│   │   ├── PaymentScreen.swift          # Payment options (Credit Card, Apple Pay, UPI, Net Banking), point discount
│   │   └── PaymentConfirmationView.swift# Purchase confirmation modal/screen with animated success & order details
│   └── Orders/
│       ├── OrderHistoryView.swift       # User order history with "Buy In Again" and "Cancel Order within 48h"
│       └── OrderDetailView.swift        # Single order detail with cancellation timer badge
└── Resources/
    └── MockData.swift                   # Seed data for books, categories, publishers, orders, addresses
```

---

## Sub-Tasks

### Sub-Task 1: Project Setup, Theme, Foundation & Models
- **Intent**: Establish the core data models, theme tokens (colors, typography, radii, spacing), and package structure for `BookstoreApp`.
- **Expected Outcomes**:
  - Full set of Swift models (`Book`, `Category`, `BrandPublisher`, `CartItem`, `Order`, `Address`, `UserProfile`) conforming to `Identifiable` and `Codable`.
  - Design system in `Theme/Colors.swift`, `Typography.swift`, and `Layout.swift`.
  - Rich seed data in `MockData.swift` with diverse books, categories, brands, past orders, and user points balance.
- **Todo List**:
  1. Create `BookstoreApp/Package.swift` and folder structure.
  2. Implement `Data/Models/Book.swift`, `Category.swift`, `BrandPublisher.swift`, `CartItem.swift`, `Order.swift`, `Address.swift`, `UserProfile.swift`.
  3. Implement `Theme/Colors.swift` and `Theme/Typography.swift`.
  4. Implement `Resources/MockData.swift` with realistic bookstore mock data.
- **Relevant Context**:
  - `FlightBookingApp/Theme/Colors.swift` as reference for design system architecture.
  - Swift iOS 16/17 compatibility.
- **Status**: `[x] done`

---

### Sub-Task 2: Reusable UI Components & Navigation Framework
- **Intent**: Build reusable UI components (custom navbar, responsive book cards, category chips, primary buttons) and top/tab navigation structure.
- **Expected Outcomes**:
  - Responsive layout components adapt smoothly across light/dark modes and dynamic screen sizes.
  - Reusable `NavigationHeader`, `BookCard`, `CategoryChip`, `BrandCard`, and `PrimaryButton`.
  - Root `ContentView` with a 4-tab bar (Home/Catalogue, Search/Categories, Orders, Cart).
- **Todo List**:
  1. Create `Views/Components/NavigationHeader.swift` with title, cart badge count, and search button.
  2. Create `Views/Components/BookCard.swift` supporting grid and horizontal list layout modes.
  3. Create `Views/Components/CategoryChip.swift` and `Views/Components/BrandCard.swift`.
  4. Create `Views/Components/PrimaryButton.swift` and `SectionHeader.swift`.
  5. Assemble `ContentView.swift` with bottom TabView structure.
- **Relevant Context**:
  - Visual styling inspired by modern bookstore mobile apps.
- **Status**: `[x] done`

---

### Sub-Task 3: Authentication & Home Landing Catalogue Screen
- **Intent**: Implement user authentication view and the home catalogue landing page with hero banners, category chips, top authors/brands, and recommended books.
- **Expected Outcomes**:
  - `AuthViewModel` handling user login/logout state — **already implemented**.
  - `LoginView` with clean text fields, password toggle, and mock auth validation — **already implemented**.
  - `CatalogueViewModel` with search, category/brand filtering, and featured/bestseller computed properties — **already implemented**.
  - `HomeCatalogueView` showcasing featured books carousel, category chip row, popular publishers/brands section, and quick-reorder shortcut.
- **Todo List**:
  1. ~~Build `ViewModels/AuthViewModel.swift`.~~ (done)
  2. ~~Implement `Views/Auth/LoginView.swift`.~~ (done)
  3. ~~Build `ViewModels/CatalogueViewModel.swift`.~~ (done)
  4. Implement `Views/Catalogue/HomeCatalogueView.swift` with responsive grid layouts.
- **Relevant Context**:
  - `ContentView.swift` has placeholder `HomeTabPlaceholder` — replace with real `HomeCatalogueView`.
  - `CatalogueViewModel` exposes `.featuredBooks`, `.bestsellerBooks`, `.categories`, `.publishers`.
  - `BookCard` supports `.grid` and `.horizontal` modes; use `.horizontal` for carousel sections.
  - `SectionHeader` supports "See All" callback for navigating to `CategoryDetailView`.
  - `NavigationHeader` is stateless, driven by callbacks for search tap and cart tap.
  - `MockData` provides 8 sample books, 8 categories, 6 publishers.
- **Status**: `[ ] pending`

---

### Sub-Task 4: Category Filtering, Brand Browsing & Product Detail Screen
- **Intent**: Implement category selection, brand/publisher browsing, and comprehensive book detail screen with tentative delivery dates and related item recommendations.
- **Expected Outcomes**:
  - `CategoryDetailView` with category-specific `CategoryChip` filter row, horizontal `BrandCard` scroller, sort options, and filtered `BookCard` grid.
  - `BookDetailView` presenting cover art, author, rating, tentative delivery date badge (e.g. "Delivers by Friday, Oct 24"), stock status, format picker (Hardcover, Paperback, E-Book), and related books horizontal carousel.
- **Todo List**:
  1. Build `Views/Catalogue/CategoryDetailView.swift` with brand filtering driven by `CatalogueViewModel`.
  2. Implement `Views/Catalogue/BookDetailView.swift` using `Book.tentativeDeliveryDateString` computed property.
  3. Add "Related Products" row inside `BookDetailView` using `CatalogueViewModel.relatedBooks(for:)`.
  4. Connect "Add to Basket" button in `BookDetailView` to `CartViewModel.addItem()`.
- **Relevant Context**:
  - `CatalogueViewModel.selectCategory()` and `selectPublisher()` drive filter state.
  - `Book.tentativeDeliveryDateString` is a computed property already on the model.
  - `BookCard(.horizontal)` is suitable for the related products carousel.
  - `CategoryChip` and `BrandCard` are ready for use.
  - `CartViewModel` will be created in Sub-Task 5 — wire the "Add to Basket" call after that VM exists.
- **Status**: `[ ] pending`

---

### Sub-Task 5: Shopping Cart, Order History-Based Recommendations & Address Selection
- **Intent**: Build cart management, gift point redemption calculations, personalized recommendations driven by past purchase history, and delivery address selection.
- **Expected Outcomes**:
  - `CartViewModel` managing item quantities, price totals, delivery fee, and gift points discount.
  - `ShoppingCartView` displaying active basket items, recommendation section based on order history ("Because you bought..."), and gift point redeem toggle.
  - `CheckoutAddressView` allowing user to select or add a delivery address.
- **Todo List**:
  1. Implement `ViewModels/CartViewModel.swift` with `addItem()`, `removeItem()`, `updateQuantity()`, gift point toggle, and recommendation logic derived from `OrderViewModel`'s past order items.
  2. Build `Views/Cart/ShoppingCartView.swift` with line items, subtotal/discount/shipping/total breakdown, recommendations carousel, and gift point redeem toggle.
  3. Build `Views/Cart/CheckoutAddressView.swift` with selectable `Address` cards and a default address indicator.
- **Relevant Context**:
  - `CartItem` model has `totalPrice` and `formattedTotalPrice` computed properties.
  - `UserProfile.giftPointsDollarValue` and `formattedGiftPointsValue` for points display.
  - `MockData.sampleAddresses` for address list seeding.
  - `OrderRowView` is already built; the recommendation carousel can reuse `BookCard(.horizontal)`.
  - Recommendations: filter books that appear in `MockData.sampleOrders` items but are not already in cart.
- **Status**: `[ ] pending`

---

### Sub-Task 6: Payment Options, Purchase Confirmation & Order Cancellation
- **Intent**: Create payment initiation screen with multiple options, purchase completion modal/screen, order history screen with "Buy In Again", and 48-hour order cancellation workflow.
- **Expected Outcomes**:
  - `PaymentScreen` supporting Credit/Debit Card, Apple Pay, UPI, and Net Banking options.
  - `PaymentConfirmationView` showing success animation, purchase order ID, summary, and action to view order details.
  - `OrderViewModel` managing order creation and cancellation windows.
  - `OrderHistoryView` displaying past orders using `OrderRowView`, with 48-hour countdown status for active orders.
  - `OrderDetailView` with full order breakdown and inline cancellation CTA.
- **Todo List**:
  1. Implement `Views/Payment/PaymentScreen.swift` with payment method selector and order summary breakdown.
  2. Create `Views/Payment/PaymentConfirmationView.swift` with success checkmark animation and order summary.
  3. Implement `ViewModels/OrderViewModel.swift` with `cancelOrder()` (guarded by `order.canBeCancelled`) and `buyAgain()` handler that pushes items to `CartViewModel`.
  4. Build `Views/Orders/OrderHistoryView.swift` using `OrderRowView` driven by `OrderViewModel`.
  5. Build `Views/Orders/OrderDetailView.swift` with cancellation countdown badge.
- **Relevant Context**:
  - `Order.canBeCancelled` and `Order.remainingCancelHours` are computed properties on the model.
  - `OrderRowView` is fully built; `OrderHistoryView` wraps it in a `List` or `LazyVStack`.
  - `MockData.sampleOrders` includes orders at varying statuses and timestamps to exercise all cancel/no-cancel states.
  - `PaymentConfirmationView` can be presented as a `.sheet` or full-screen cover from `PaymentScreen`.
- **Status**: `[ ] pending`

---

### Sub-Task 7: Root Wiring, Entry Point & Build Verification
- **Intent**: Wire all screens together in `BookstoreApp.swift` and `ContentView.swift`, add Xcode documentation in `README.md`, and verify project files compile cleanly.
- **Expected Outcomes**:
  - `BookstoreApp.swift` application entry point with `AuthViewModel`, `CartViewModel`, and `OrderViewModel` injected as `.environmentObject`.
  - `ContentView.swift` tab placeholders replaced with real screen views.
  - `README.md` with instructions on opening in Xcode and architecture highlights.
  - Clean build with no errors.
- **Todo List**:
  1. Create `BookstoreApp/BookstoreApp.swift` `@main` entry file injecting `AuthViewModel`, `CartViewModel`, `OrderViewModel` as environment objects.
  2. Update `ContentView.swift` to replace all placeholder stubs with real views (`HomeCatalogueView`, `CategoryDetailView`, `ShoppingCartView`, `OrderHistoryView`).
  3. Update `BookstoreApp/README.md`.
  4. Verify all file imports, symbol references, and MVVM environment object flows are consistent.
- **Relevant Context**:
  - `ContentView.swift` currently uses `HomeTabPlaceholder`, `SearchTabPlaceholder`, `CartTabPlaceholder`, `OrdersTabPlaceholder` — all four need replacing.
  - `AuthViewModel` is already `@ObservableObject`; `CartViewModel` and `OrderViewModel` will follow the same pattern.
  - `LoginView` requires `AuthViewModel` as `@EnvironmentObject`.
- **Status**: `[ ] pending`

---

## Architectural & Navigation Flow Diagram

```
+-----------------------------------------------------------------------+
|                             BookstoreApp                              |
+-----------------------------------------------------------------------+
                                    |
          +-------------------------+-------------------------+
          |                         |                         |
  +---------------+        +-----------------+        +---------------+
  | AuthViewModel |        | CartViewModel   |        | OrderViewModel|
  +---------------+        +-----------------+        +---------------+
          |                         |                         |
          v                         v                         v
+-----------------------------------------------------------------------+
|                              ContentView                              |
|                          (Root Tab Bar View)                          |
+-----------------------------------------------------------------------+
   |                  |                    |                  |
   v                  v                    v                  v
[Home Tab]       [Category Tab]       [Cart Tab]        [Orders Tab]
   |                  |                    |                  |
   v                  v                    v                  v
HomeCatalogue     CategoryDetail      ShoppingCart       OrderHistory
   |                  |                    |                  |
   v                  v                    v                  v
BookDetail -------> BrandBrowsing    CheckoutAddress    OrderDetail
   |                  |                    |                  |
   +------------------+                    v                  v
                      |              PaymentScreen     Cancel Order (<48h)
                      |                    |             Buy In Again
                      +-------------> Confirmation
```
