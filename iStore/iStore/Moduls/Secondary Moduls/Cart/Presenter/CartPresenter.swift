import Foundation
import UIKit

protocol CartPresenterProtocol: AnyObject {
    var itemsCount: Int { get }
    var totalPrice: Double { get set }
    var selectedPrices: [Double] { get set }

    func getData()
    func getItem(at index: Int) -> ChosenItem

    func showDetailsVC(data: SingleProduct)

    func addToTotals(amount: Double)
    func removeFromTotals(at index: Int)
    func deleteItem(at indexPath: IndexPath, tableView: UITableView)
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartVCProtocol?
    var items: [ChosenItem] = []
    var selectedPrices: [Double] = []
    var totalPrice = 0.0
    var deleteButtonAction: (() -> Void)?

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
        items = [ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 100.00),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 150.00),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 399.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 599.99)
        ]
    }

    // MARK: Navigation Methods

//    func showPaymentVC() {
//        router.showPaymentVC()
//    }

    func showDetailsVC(data: SingleProduct) {
//        let detailsVC = DetailsVC(data: mockItem)
//        self.navigationController.pushViewController(detailsVC, animated: true)
    }

    // MARK: Methods for editing of prices

    func addToTotals(amount: Double) {
        selectedPrices.append(amount)
        print("элементы корзины после добавления:", selectedPrices)
        totalPrice = selectedPrices.reduce(0, +)
    }

    func removeFromTotals(at index: Int) {
        selectedPrices.remove(at: index)
        print("элементы корзины после удаления:", selectedPrices)
        totalPrice = selectedPrices.reduce(0, +)
    }

    // функция для удаления суммы из корзины по значению, а не индексу. =костыль для решения бага с моментом, когда в selectedPrice добавляются айтемы по одному
//    func removeByAmount(of amount: Double) {
//        selectedPrices.append(-amount)
//        totalPrice = selectedPrices.reduce(0, +)
//    }

    #warning("выходит за пределы индекса, если удалить например 1ю ячейку, а потом последнюю. Проверить после подключения сети")
    func deleteItem(at indexPath: IndexPath, tableView: UITableView) {
        let itemToDelete = items[indexPath.row]
        let indexToDelete = selectedPrices.firstIndex(of: itemToDelete.price) ?? 0
        items.remove(at: indexPath.row)
        removeFromTotals(at: indexToDelete)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}
