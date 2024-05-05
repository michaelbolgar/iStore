
/// screen for tests of new features. Here you can add some examples of your code for other teammates

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
//        getCategories()
//        getProductsByCategory(for: 1)
//        getProduct(for: 51)
        deSearch(for: "shoes")
    }

    // MARK: Network methods examples

    /// get all categories
    private func getCategories() {
        NetworkingManager.shared.getCategories { result in
            switch result {
            case .success(let categories):
                print("Current collections: \(categories)")
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }

    /// get items by certain category
    private func getProductsByCategory(for id: Int) {
        NetworkingManager.shared.getProductsByCategory(for: id) { result in
            switch result {
            case .success(let categories):
                print("Products in category: \(categories)")
            case .failure(let error):
                print("Error fetching: \(error)")
            }
        }
    }

    /// get item details
    private func getProduct(for id: Int) {
        NetworkingManager.shared.getProduct(for: id) { result in
            switch result {
            case .success(let product):
                print("Info about product: \(product)")
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }

    /// search for items
    private func deSearch(for request: String) {
        NetworkingManager.shared.doSearch(for: request) { result in
            switch result {
            case .success(let product):
                print("Info about product: \(product)")
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }
}
