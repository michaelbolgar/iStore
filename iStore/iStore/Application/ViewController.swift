// экран для быстрых тестов разных фич, как например запросы по апи. Можно оставлять тут примеры для других участников команды

import UIKit

class ViewController: UIViewController {

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemCyan
//        getCategories()
//        getProductsByCategory(for: 1)
//        getProduct(for: 51)
        deSearch(for: "shoes")
    }

    // MARK: Network methods

    /// получить все (пять) категорий
    func getCategories() {
        NetworkingManager.shared.getCategories { result in
            switch result {
            case .success(let categories):
                print("Current collections: \(categories)")
            case .failure(let error):
                print("Error fetching collections: \(error)")
            }
        }
    }

    /// получить товары по категории,
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

    /// получить инфу по конкретному товару
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
