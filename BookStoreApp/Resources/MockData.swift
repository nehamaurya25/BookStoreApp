//
// MockData.swift
// BookstoreApp
//

import Foundation

public struct MockData {
    
    // MARK: - User Profile
    public static let sampleUser = UserProfile(
        id: "usr_101",
        name: "Alex Morgan",
        email: "alex.morgan@example.com",
        avatarImageName: "person.crop.circle.fill",
        giftPointsBalance: 420, // $21.00 value
        memberTier: "Gold Reader",
        defaultAddressId: "addr_1"
    )
    
    // MARK: - Addresses
    public static let sampleAddresses: [Address] = [
        Address(
            id: "addr_1",
            recipientName: "Alex Morgan",
            streetAddress: "742 Evergreen Terrace",
            apartmentSuite: "Apt 4B",
            city: "Springfield",
            state: "OR",
            zipCode: "97477",
            country: "United States",
            phoneNumber: "+1 (555) 234-5678",
            isDefault: true
        ),
        Address(
            id: "addr_2",
            recipientName: "Alex Morgan (Office)",
            streetAddress: "100 Innovation Way",
            apartmentSuite: "Suite 1200",
            city: "Seattle",
            state: "WA",
            zipCode: "98101",
            country: "United States",
            phoneNumber: "+1 (555) 987-6543",
            isDefault: false
        )
    ]
    
    // MARK: - Categories
    public static let sampleCategories: [Category] = [
        Category(id: "cat_fiction", name: "Fiction & Literature", systemIcon: "book.fill", description: "Novels, contemporary classics & prose", bookCount: 1420),
        Category(id: "cat_scifi", name: "Sci-Fi & Fantasy", systemIcon: "wand.and.stars", description: "Futuristic worlds, space & epic fantasy", bookCount: 890),
        Category(id: "cat_mystery", name: "Mystery & Thriller", systemIcon: "magnifyingglass", description: "Suspense, crime, & detective novels", bookCount: 760),
        Category(id: "cat_business", name: "Business & Finance", systemIcon: "chart.bar.fill", description: "Leadership, investing & strategy", bookCount: 540),
        Category(id: "cat_tech", name: "Tech & Computer Science", systemIcon: "cpu", description: "Software design, AI, & coding guides", bookCount: 430),
        Category(id: "cat_biography", name: "Biography & Memoir", systemIcon: "person.text.rectangle", description: "Inspiring lives & historical figures", bookCount: 610),
        Category(id: "cat_history", name: "History & Politics", systemIcon: "building.columns", description: "World history, events & diplomacy", bookCount: 510),
        Category(id: "cat_selfhelp", name: "Self-Help & Mindset", systemIcon: "heart.text.square.fill", description: "Personal growth & mindfulness", bookCount: 980)
    ]
    
    // MARK: - Publishers / Brands
    public static let samplePublishers: [BrandPublisher] = [
        BrandPublisher(id: "pub_penguin", name: "Penguin Random House", logoIcon: "bird.fill", country: "United States", foundedYear: 1927, titleCount: 4500, isPopular: true),
        BrandPublisher(id: "pub_harper", name: "HarperCollins", logoIcon: "flame.fill", country: "United States", foundedYear: 1817, titleCount: 3800, isPopular: true),
        BrandPublisher(id: "pub_simon", name: "Simon & Schuster", logoIcon: "bookmark.fill", country: "United States", foundedYear: 1924, titleCount: 2900, isPopular: true),
        BrandPublisher(id: "pub_hachette", name: "Hachette Book Group", logoIcon: "books.vertical.fill", country: "France", foundedYear: 1826, titleCount: 2200, isPopular: true),
        BrandPublisher(id: "pub_oreilly", name: "O'Reilly Media", logoIcon: "desktopcomputer", country: "United States", foundedYear: 1978, titleCount: 1100, isPopular: true),
        BrandPublisher(id: "pub_bloomsbury", name: "Bloomsbury Publishing", logoIcon: "crown.fill", country: "United Kingdom", foundedYear: 1986, titleCount: 1700, isPopular: true)
    ]
    
    // MARK: - Books
    public static let sampleBooks: [Book] = [
        Book(
            id: "book_001",
            title: "The Midnight Library",
            author: "Matt Haig",
            publisherId: "pub_penguin",
            publisherName: "Penguin Random House",
            categoryId: "cat_fiction",
            categoryName: "Fiction & Literature",
            price: 18.99,
            originalPrice: 26.00,
            rating: 4.8,
            reviewCount: 3420,
            format: "Hardcover",
            pageCount: 304,
            isbn: "978-0525559474",
            description: "Between life and death there is a library, and within that library, the shelves go on forever. Every book provides a chance to try another life you could have lived.",
            coverImageName: "book.closed.fill",
            coverColorHex: "#1E3A8A", // Indigo Navy
            estimatedDeliveryDays: 2,
            isFeatured: true,
            isBestseller: true,
            stockCount: 45,
            relatedBookIds: ["book_002", "book_003", "book_005"]
        ),
        Book(
            id: "book_002",
            title: "Project Hail Mary",
            author: "Andy Weir",
            publisherId: "pub_penguin",
            publisherName: "Penguin Random House",
            categoryId: "cat_scifi",
            categoryName: "Sci-Fi & Fantasy",
            price: 21.50,
            originalPrice: 28.99,
            rating: 4.9,
            reviewCount: 5120,
            format: "Hardcover",
            pageCount: 496,
            isbn: "978-0593135204",
            description: "Ryland Grace is the sole survivor on a desperate, last-chance mission—and if he fails, humanity and the earth itself will perish.",
            coverImageName: "sparkles",
            coverColorHex: "#D97706", // Amber
            estimatedDeliveryDays: 3,
            isFeatured: true,
            isBestseller: true,
            stockCount: 30,
            relatedBookIds: ["book_001", "book_004", "book_006"]
        ),
        Book(
            id: "book_003",
            title: "Atomic Habits",
            author: "James Clear",
            publisherId: "pub_penguin",
            publisherName: "Penguin Random House",
            categoryId: "cat_selfhelp",
            categoryName: "Self-Help & Mindset",
            price: 16.20,
            originalPrice: 27.00,
            rating: 4.9,
            reviewCount: 8900,
            format: "Paperback",
            pageCount: 320,
            isbn: "978-0735211292",
            description: "No matter your goals, Atomic Habits offers a proven framework for improving—every day. Learn how small changes lead to remarkable results.",
            coverImageName: "bolt.fill",
            coverColorHex: "#059669", // Emerald
            estimatedDeliveryDays: 1,
            isFeatured: true,
            isBestseller: true,
            stockCount: 80,
            relatedBookIds: ["book_004", "book_007", "book_008"]
        ),
        Book(
            id: "book_004",
            title: "Designing Data-Intensive Applications",
            author: "Martin Kleppmann",
            publisherId: "pub_oreilly",
            publisherName: "O'Reilly Media",
            categoryId: "cat_tech",
            categoryName: "Tech & Computer Science",
            price: 39.99,
            originalPrice: 49.99,
            rating: 4.9,
            reviewCount: 1840,
            format: "Paperback",
            pageCount: 616,
            isbn: "978-1449373320",
            description: "Data is at the center of many challenges in system design today. Learn the pros and cons of various technologies for processing and storing data.",
            coverImageName: "cpu.fill",
            coverColorHex: "#2563EB", // Blue
            estimatedDeliveryDays: 2,
            isFeatured: false,
            isBestseller: true,
            stockCount: 18,
            relatedBookIds: ["book_003", "book_008"]
        ),
        Book(
            id: "book_005",
            title: "The Silent Patient",
            author: "Alex Michaelides",
            publisherId: "pub_hachette",
            publisherName: "Hachette Book Group",
            categoryId: "cat_mystery",
            categoryName: "Mystery & Thriller",
            price: 14.99,
            originalPrice: 17.99,
            rating: 4.6,
            reviewCount: 4200,
            format: "Paperback",
            pageCount: 336,
            isbn: "978-1250301697",
            description: "Alicia Berenson's life is seemingly perfect. Then one evening she shoots her husband five times in the face, and never speaks another word.",
            coverImageName: "eye.fill",
            coverColorHex: "#DC2626", // Red
            estimatedDeliveryDays: 3,
            isFeatured: false,
            isBestseller: true,
            stockCount: 22,
            relatedBookIds: ["book_001", "book_002"]
        ),
        Book(
            id: "book_006",
            title: "Dune",
            author: "Frank Herbert",
            publisherId: "pub_penguin",
            publisherName: "Penguin Random House",
            categoryId: "cat_scifi",
            categoryName: "Sci-Fi & Fantasy",
            price: 17.50,
            originalPrice: 22.00,
            rating: 4.8,
            reviewCount: 6700,
            format: "Paperback",
            pageCount: 688,
            isbn: "978-0441172719",
            description: "Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides, who will become the mysterious man known as Muad'Dib.",
            coverImageName: "sun.max.fill",
            coverColorHex: "#EA580C", // Orange
            estimatedDeliveryDays: 2,
            isFeatured: true,
            isBestseller: true,
            stockCount: 35,
            relatedBookIds: ["book_002", "book_001"]
        ),
        Book(
            id: "book_007",
            title: "Steve Jobs",
            author: "Walter Isaacson",
            publisherId: "pub_simon",
            publisherName: "Simon & Schuster",
            categoryId: "cat_biography",
            categoryName: "Biography & Memoir",
            price: 22.00,
            originalPrice: 30.00,
            rating: 4.7,
            reviewCount: 2890,
            format: "Hardcover",
            pageCount: 656,
            isbn: "978-1451648539",
            description: "Based on more than forty interviews with Jobs conducted over two years, this is the definitive biography of the legendary Apple founder.",
            coverImageName: "applelogo",
            coverColorHex: "#4B5563", // Gray
            estimatedDeliveryDays: 3,
            isFeatured: false,
            isBestseller: false,
            stockCount: 12,
            relatedBookIds: ["book_003", "book_004"]
        ),
        Book(
            id: "book_008",
            title: "The Psychology of Money",
            author: "Morgan Housel",
            publisherId: "pub_harper",
            publisherName: "HarperCollins",
            categoryId: "cat_business",
            categoryName: "Business & Finance",
            price: 15.80,
            originalPrice: 19.99,
            rating: 4.8,
            reviewCount: 4900,
            format: "Paperback",
            pageCount: 256,
            isbn: "978-0857197689",
            description: "Doing well with money isn't necessarily about what you know. It's about how you behave. And behavior is hard to teach, even to really smart people.",
            coverImageName: "dollarsign.circle.fill",
            coverColorHex: "#10B981", // Emerald
            estimatedDeliveryDays: 1,
            isFeatured: true,
            isBestseller: true,
            stockCount: 60,
            relatedBookIds: ["book_003", "book_004"]
        )
    ]
    
    // MARK: - Sample Orders (For Order History & Cancellation Testing)
    public static let sampleOrders: [Order] = [
        // Order placed 6 hours ago (Eligible for 48h cancellation)
        Order(
            id: "ord_201",
            orderNumber: "BK-893041",
            orderDate: Date().addingTimeInterval(-6 * 3600), // 6 hours ago
            status: .processing,
            items: [
                CartItem(book: sampleBooks[0], quantity: 1, selectedFormat: "Hardcover"),
                CartItem(book: sampleBooks[2], quantity: 1, selectedFormat: "Paperback")
            ],
            shippingAddress: sampleAddresses[0],
            paymentMethodName: "Apple Pay",
            subtotal: 35.19,
            discountAmount: 5.00,
            shippingFee: 0.00,
            totalAmount: 30.19,
            pointsEarned: 30,
            pointsRedeemed: 100
        ),
        
        // Order placed 1 day ago (Eligible for 48h cancellation)
        Order(
            id: "ord_202",
            orderNumber: "BK-884120",
            orderDate: Date().addingTimeInterval(-26 * 3600), // 26 hours ago
            status: .processing,
            items: [
                CartItem(book: sampleBooks[1], quantity: 1, selectedFormat: "Hardcover")
            ],
            shippingAddress: sampleAddresses[0],
            paymentMethodName: "Visa (•••• 4242)",
            subtotal: 21.50,
            discountAmount: 0.00,
            shippingFee: 3.99,
            totalAmount: 25.49,
            pointsEarned: 25,
            pointsRedeemed: 0
        ),
        
        // Order placed 5 days ago (Shipped, no longer eligible for cancellation)
        Order(
            id: "ord_198",
            orderNumber: "BK-771029",
            orderDate: Date().addingTimeInterval(-120 * 3600), // 5 days ago
            status: .shipped,
            items: [
                CartItem(book: sampleBooks[3], quantity: 1, selectedFormat: "Paperback")
            ],
            shippingAddress: sampleAddresses[1],
            paymentMethodName: "Mastercard (•••• 8812)",
            subtotal: 39.99,
            discountAmount: 0.00,
            shippingFee: 0.00,
            totalAmount: 39.99,
            pointsEarned: 40,
            pointsRedeemed: 0
        ),
        
        // Order placed 12 days ago (Delivered)
        Order(
            id: "ord_180",
            orderNumber: "BK-660144",
            orderDate: Date().addingTimeInterval(-288 * 3600), // 12 days ago
            status: .delivered,
            items: [
                CartItem(book: sampleBooks[7], quantity: 2, selectedFormat: "Paperback")
            ],
            shippingAddress: sampleAddresses[0],
            paymentMethodName: "Visa (•••• 4242)",
            subtotal: 31.60,
            discountAmount: 0.00,
            shippingFee: 0.00,
            totalAmount: 31.60,
            pointsEarned: 32,
            pointsRedeemed: 0
        )
    ]
}
