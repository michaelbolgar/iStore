import Foundation

enum Endpoint {
    case getCategories
    case getProductsByCategory(id: Int)
    case getProduct(id: Int)
    case doSearch(request: String)
    case updateCategory(id: Int)
    case deleteProduct(id: Int)
    
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
        case .updateCategory(id: let id):
            return "/api/v1/categories/\(id)"
        case .deleteProduct(id: let id):
            return "/api/v1/products/\(id)"
        }
    }
}
