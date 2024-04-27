import Foundation

/// struct for single item
struct SingleProduct: Codable {
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
    let images: [String?]
    let category: Category
    
    static var placeholder: SingleProduct {
            return SingleProduct(id: nil, title: "Unavailable Product", price: nil, description: "No description available.", images: [], category: Category.placeholder)
        }
}

/// struct for single category
struct Category: Codable {
    let id: Int?
    let name: String?
    let image: String?
    
    static var placeholder: Category {
            return Category(id: nil, name: "No Category", image: nil)
        }
}
