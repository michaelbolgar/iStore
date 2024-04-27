

import Foundation

protocol ProductPresenterProtocol: AnyObject {
  //  func viewDidLoad()
уы    var productCount: Int { get }
    func getProduct(at index: Int) -> ProductVCModel
}

final class ProductPresenter: ProductPresenterProtocol {
    
    weak var view: ProductVCProtocol?
    var products: [ProductVCModel] = []
    
    init(viewController: ProductVC? = nil) {
        self.view = viewController
    }
    var productCount: Int {
        return products.count
    }
    
    func getProduct(at index: Int) -> ProductVCModel {
        return products[index]
    }
    
    func fetchProductsByCategory(categoryId: String) {
        NetworkingManager.shared.doSearch(for: categoryId) { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products.map { product in
                    // Проверяем, что массив images не пустой
                    if let firstImageString = product.images.first,
                       let imageData = firstImageString!.data(using: .utf8),
                       let imageUrls = try? JSONDecoder().decode([String].self, from: imageData),
                       let firstImageUrlString = imageUrls.first,
                       let firstImageUrl = URL(string: firstImageUrlString) {
                        // Создаем экземпляр Product с изображением
                        return ProductVCModel(id: product.id,
                                              image: firstImageUrl.absoluteString,
                                              description: product.description,
                                              price: Double(product.price ?? 0))
                    } else {
                        // Создаем экземпляр Product без изображения
                        return ProductVCModel(id: product.id,
                                              image: nil,
                                              description: product.description,
                                              price: Double(product.price ?? 0))
                    }
                }
                // Обновляем представление, чтобы отобразить новые продукты
                self?.view?.reloadCollectionView()
            case .failure(let error):
                // Обрабатываем ошибку
                print("Failed to fetch products: \(error)")
            }
        }
    }
    


}

//MARK: - WishCollectionCellDelegate
extension ProductPresenter: ProductCollectionCellDelegate {
    func deleteButtonPressed() {
        print("Delete pressed")
    }
    
    func updateButtonPressed() {
        print("update pressed")
    }
}
