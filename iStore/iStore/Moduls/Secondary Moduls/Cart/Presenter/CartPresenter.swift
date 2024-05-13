import Foundation
import UIKit

protocol CartPresenterProtocol: AnyObject {

    /// properties
    var items: [ChosenItem] { get }
    var selectedItems: SelectedItems { get set }
    var itemsCount: Int { get }

    //    var totalPrice: Double { get set }
    //    var selectedPrices: [Double] { get set }

    /// set data
    func getItem(at index: Int) -> ChosenItem
    func setData()

    /// update cart information
    func addToTotals(at index: Int)
    func removeFromTotals(at index: Int)
    func deleteItem(at indexPath: IndexPath, tableView: UITableView)
    func tappedPlusButton(at index: IndexPath)
    func tappedMinusButton(at index: IndexPath)
    func tappedCheckmarkButton(at index: IndexPath)

    /// navigation
    func showDetailsVC(data: SingleProduct)
}

final class CartPresenter: CartPresenterProtocol {

    weak var view: CartVCProtocol?

    /// all items in the cart
    var items: [ChosenItem] = []

    /// with green checkmark selected items
    var selectedItems = SelectedItems(items: [])

//    var selectedPrices: [Double] = []
    lazy var totalPrice = selectedItems.totalPrice

    var itemsCount: Int {
        return items.count
    }

    var deleteButtonAction: (() -> Void)?

    /// mock data
//    lazy var mockCategory = Category(id: 1, name: "technik", image: "")
//    lazy var mockItem = SingleProduct(id: 1, title: "iPhone SE", price: 1000, description: "The best iPhone ever", images: [""], category: mockCategory)

    // MARK: Init
    init(viewController: CartVC? = nil /*router: HomeRouterProtocol*/) {
        self.view = viewController
//        self.router = router
    }

    // MARK: Methods

    func getItem(at index: Int) -> ChosenItem {
        return items[index]
    }
    func setData() {
        items = [ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 100.00),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods pro by Apple", smallTitle: "Variant: Grey", price: 150.00),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods fail by honor", smallTitle: "Variant: Grey", price: 399.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods middle by Apple", smallTitle: "Variant: Grey", price: 599.99)
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

    func updateTotals() {
        totalPrice = selectedItems.totalPrice
    }

    func addToTotals(at index: Int) {
        let item = items[index]
        selectedItems.items.append(item)
        print (selectedItems.items)
        updateTotals()
    }

    // пока что завязано только на снятии галочки
    func removeFromTotals(at index: Int) {
        if !selectedItems.items.isEmpty {
            let item = items[index]
            selectedItems.items.removeAll { $0.bigTitle == item.bigTitle }
            print (selectedItems.items)
            updateTotals()

            // нужно развести логику выделения и удаления из корзины полностью
        }
    }

    func removeFromTotalsByAmount(of amount: Double) {
//        selectedPrices.append(-amount)
//        totalPrice = selectedPrices.reduce(0, +)
//        totalPrice -= amount

        print ("удалить из выбранных")
    }

    func deleteItem(at indexPath: IndexPath, tableView: UITableView) {
//        let itemToDelete = items[indexPath.row]
//        let indexToDelete = selectedPrices.firstIndex(of: itemToDelete.price) ?? 0
//        let priceToRemove = itemToDelete.price * itemToDelete.numberOfItemsToBuy
//        print ("какую сумму сейчас будем удалять:", price)

        let itemToDelete = getItem(at: indexPath.row)
        let priceToRemove = itemToDelete.price * Double(itemToDelete.numberOfItemsToBuy)
        removeFromTotalsByAmount(of: priceToRemove)
        items.remove(at: indexPath.row)

        // логика удаления из выбранного

        tableView.deleteRows(at: [indexPath], with: .bottom)
        tableView.reloadData()
    }

    func tappedPlusButton(at index: IndexPath) {
        print ("plus tapped")
    }

    func tappedMinusButton(at index: IndexPath) {
        print ("minus tapped")
    }

    func tappedCheckmarkButton(at index: IndexPath) {
        print ("checkmark tapped")
    }

}
