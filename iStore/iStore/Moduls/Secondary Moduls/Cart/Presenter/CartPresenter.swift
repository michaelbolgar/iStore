import Foundation
import UIKit

protocol CartPresenterProtocol: AnyObject {
    var itemsCount: Int { get }
    func getData()
    func getItem(at index: Int) -> ChosenItem
}

final class CartPresenter: CartPresenterProtocol {

//    private let router: HomeRouterProtocol
    weak var view: CartVCProtocol?
    var items: [ChosenItem] = []
    var amountForPriceLabel = [Double]()

    var itemsCount: Int {
        return items.count
    }

    /// mock data
    lazy var mockCategory = Category(id: 1, name: "technik", image: "")
    lazy var mockItem = SingleProduct(id: 1, title: "iPhone SE", price: 1000, description: "The best iPhone ever", images: [""], category: mockCategory)

    // MARK: Init
    init(viewController: CartVC? = nil /*router: HomeRouterProtocol*/) {
        self.view = viewController
//        self.router = router
    }


    // MARK: Methods

    func getItem(at index: Int) -> ChosenItem {
        return items[index]
    }
    func getData() {
        items = [ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 99.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 299.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 399.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 599.99)
        ]
    }

//    func showPaymentVC() {
//        router.showPaymentVC()
//    }

    func showDetailsVC(data: SingleProduct) {
//        let detailsVC = DetailsVC(data: mockItem)
//        self.navigationController.pushViewController(detailsVC, animated: true)
    }

    func deleteItem(at indexPath: IndexPath, tableView: UITableView) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
