import Foundation

/// struct for a single item
struct SingleProduct: Codable {
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
    let images: [String?]
    let category: Category
}

/// struct for a single category
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
}
