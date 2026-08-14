# BookstoreApp

A fully featured e-bookstore iOS app built with **SwiftUI**, following clean **MVVM** architecture with no external dependencies.

---

## Requirements

- Xcode 15+
- iOS 16.0+ deployment target
- Swift 5.9+

---

## Opening in Xcode

Because this project uses Swift Package Manager (no `.xcodeproj`), open it one of two ways:

**Option A — Workspace (recommended)**
```
open .swiftpm/xcode/package.xcworkspace
```

**Option B — Package.swift**  
Double-click `Package.swift` in Finder, or:
```
open Package.swift
```

Then select an iPhone simulator and press **⌘R**.

---

## Architecture

```
MVVM  ─  Views are stateless; all business logic lives in ObservableObject ViewModels.
```

| Layer | Responsibility |
|---|---|
| `Data/Models/` | Plain Swift structs — `Identifiable`, `Codable`, `Hashable` |
| `Resources/MockData.swift` | Seed data for books, categories, publishers, orders, addresses |
| `ViewModels/` | `@ObservableObject` classes injected as `.environmentObject` |
| `Views/Components/` | Stateless, reusable UI primitives driven by callbacks |
| `Views/` | Full screens composed from components + ViewModels |
| `Theme/` | `AppColors`, `AppFonts`, `AppSpacing`, `AppRadius`, `AppLayout` |

---

## Navigation Flow

```
BookstoreApp (@main)
 └── AuthViewModel (@StateObject)
      ├── LoginView          (unauthenticated)
      └── ContentView        (authenticated, 4-tab shell)
           ├── [Home]   NavigationStack → HomeCatalogueView → BookDetailView
           ├── [Search] NavigationStack → CategoryDetailView → BookDetailView
           ├── [Cart]   NavigationStack → ShoppingCartView
           │                               └── sheet: CheckoutAddressView
           │                               └── push:  PaymentScreen → PaymentConfirmationView
           └── [Orders] NavigationStack → OrderHistoryView → OrderDetailView
```

---

## ViewModels

| ViewModel | Injected at | Key responsibilities |
|---|---|---|
| `AuthViewModel` | `BookstoreApp.swift` | Login, signup, logout, gift-point redemption |
| `CatalogueViewModel` | `ContentView` | Book list, search, category & publisher filtering |
| `CartViewModel` | `ContentView` | Add/remove/update items, pricing, recommendations |
| `OrderViewModel` | `ContentView` | Order history, place order, cancel (< 48 h), buy again |

---

## Key Features

- **Home Catalogue** — hero promo banner, category chips, featured carousel, bestsellers, publishers
- **Category & Search** — search bar, category chip filter, brand/publisher selector, sort menu, adaptive grid
- **Book Detail** — cover art, tentative delivery date, stock status, format picker, related books carousel
- **Shopping Cart** — quantity stepper, gift-point redemption toggle, order-history recommendations, pricing breakdown
- **Checkout** — address selection sheet → payment method picker → order summary → pay
- **Payment Confirmation** — animated success checkmark, order summary, points earned
- **Order History** — past orders via `OrderRowView`, 48-hour cancel countdown, "Buy Again" quick-add
- **Order Detail** — full breakdown, cancellation CTA with countdown badge

---

## Pre-loaded Test Data

The app launches pre-authenticated as **Alex Morgan** (Gold Reader, 420 gift points).  
`MockData.swift` seeds:
- 8 books across 8 categories  
- 6 major publishers  
- 4 orders at varying statuses (2 cancellable, 1 shipped, 1 delivered)  
- 2 delivery addresses

To test the login screen, call `authVM.logout()` from any view, or set `isAuthenticated = false` in `AuthViewModel.init()`.
