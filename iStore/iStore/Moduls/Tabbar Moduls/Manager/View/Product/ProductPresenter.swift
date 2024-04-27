

import UIKit

protocol ProductPresenterProtocol: AnyObject {
  //  func viewDidLoad()
    var productCount: Int { get }
    func getProduct(at index: Int) -> SingleProduct
}

final class ProductPresenter: ProductPresenterProtocol {
    
    weak var view: ProductVCProtocol?
    var products: [SingleProduct] = []
    
    init(viewController: ProductVC? = nil) {
        self.view = viewController
    }
    var productCount: Int {
        return products.count
    }
    
    func getProduct(at index: Int) -> SingleProduct {
        return products[index]
    }
    
    func navToAddCategoryVC() {
        let newScreenVC = AddNewCategoryVC()
        newScreenVC.setNavigationBar(title: "Add new product")
        if let currentViewController = view as? UIViewController {
            currentViewController.navigationController?.pushViewController(newScreenVC, animated: true)
        }
    }
//
//    func deleteButtonPressed(at index: IndexPath) {
//        products.remove(at: index.item)
//    }
//    
    func fetchProductsByCategory(searchText: String) {
        NetworkingManager.shared.doSearch(for: searchText) { [ weak self ] result in
            guard let self = self else { return }
            switch result {
            case .success(let searchResults):
                DispatchQueue.main.async {
                    self.products = searchResults
                    self.view?.updateTableView(with: searchResults)
                    
                    print(self.products)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
}

//MARK: - WishCollectionCellDelegate
extension ProductPresenter: ProductCollectionCellDelegate {
    func deleteButtonPressed() {
        
    }
    
    func updateButtonPressed(with product: SingleProduct) {
        let newScreenVC = AddNewCategoryVC()
        newScreenVC.setNavigationBar(title: "Update product")
        newScreenVC.product = product
        if let currentViewController = view as? UIViewController {
            currentViewController.navigationController?.pushViewController(newScreenVC, animated: true)
        }
        
    }
    
}


