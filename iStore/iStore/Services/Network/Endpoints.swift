import Foundation

enum Endpoint {
    case getCategories
    case getProductsByCategory(id: Int)
    case getProduct(id: Int)
    case doSearch(request: String)
    case setCategoty(name: String, image: URL)

    var path: String {
        switch self {
            /// getters
        case .getCategories:
            return "/api/v1/categories"
        case .getProductsByCategory (id: let id):
            return "/api/v1/categories/\(id)/products"
        case .getProduct(id: let id):
            return "/api/v1/products/\(id)/"

            /// search
        case .doSearch:
            return "/api/v1/products"

            /// setters
        case .setCategoty:
            return "/api/v1/products"
        }
    }
}
