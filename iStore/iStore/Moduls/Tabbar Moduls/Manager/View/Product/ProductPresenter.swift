

import Foundation

protocol ProductPresenterProtocol: AnyObject {
  //  func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> Product
}

final class ProductPresenter: ProductPresenterProtocol {
    
    weak var view: ProductVCProtocol?
    var products: [Product] = []
    
    init(viewController: ProductVC? = nil) {
        self.view = viewController
    }
    var productCount: Int {
        return products.count
    }
    
    func getProduct(at index: Int) -> Product {
        return products[index]
    }
    
//    func fetchProductsByCategory(categoryId: String) {
//        NetworkingManager.shared.doSearchByTitle(title: categoryId) { [weak self] result in
//            switch result {
//            case .success(let products):
//                // Преобразуйте данные о продуктах в экземпляры Product и сохраните их в вашем презентере
//                self?.products = products.map { product in
//                    return Product(id: product.id, picture: product.images.first as! String, description: product.description, price: Double(product.price!), isFavourite: false)
//                }
//                // Обновите представление, чтобы отобразить новые продукты
//                self?.view?.reloadCollectionView()
//            case .failure(let error):
//                // Обработайте ошибку
//                print("Failed to fetch products: \(error)")
//            }
//        }
//    }


}

//MARK: - WishCollectionCellDelegate
extension ProductPresenter: ProductCollectionCellDelegate {
    func deleteButtonPressed() {
        print("Buy pressed")
    }
    
    func updateButtonPressed() {
        print("update pressed")
    }
}
