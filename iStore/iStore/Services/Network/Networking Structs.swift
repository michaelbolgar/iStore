import Foundation

/// struct for single item
struct SingleProduct: Codable {
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
    let images: [String?]
    let category: Category
}

/// struct for single category
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
}
