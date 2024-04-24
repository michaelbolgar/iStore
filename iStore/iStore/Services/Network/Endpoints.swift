import Foundation

enum Endpoint {
    case getCategories
    case getProductsByCategory(id: Int)
    case getProduct(id: Int)
    case doSearch(request: String)

    var path: String {
        switch self {
        case .getCategories:
            return "/api/v1/categories"
        case .getProductsByCategory (id: let id):
            return "/api/v1/categories/\(id)/products"
        case .getProduct(id: let id):
            return "/api/v1/products/\(id)/"
        case .doSearch:
            return "/api/v1/products"
        }
    }
}
