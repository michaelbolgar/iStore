import Foundation
import UIKit

protocol CartPresenterProtocol: AnyObject {

    /// properties
    var items: [ChosenItem] { get }
    var selectedItems: SelectedItems { get set }
    var itemsCount: Int { get }

    /// set data
    func getItem(at index: Int) -> ChosenItem
    func setData() // to delete
    func addToCart()

    /// update cart information
    func updateCell(at index: IndexPath)
    func updateTotals()
    func updateSelectedItems()

    func selectCell(at index: Int)
    func deselectCell(at index: Int)
    func deleteItem(at indexPath: IndexPath, tableView: UITableView)

    func tappedPlusButton(at index: IndexPath)
    func tappedMinusButton(at index: IndexPath)
    func tappedCheckmarkButton(at index: IndexPath)

    /// navigation
    func showDetailsVC(data: SingleProduct)
}

final class CartPresenter: CartPresenterProtocol {

    // to implement
    func addToCart() {
        print ("add to cart tapped")
    }

    weak var view: CartVCProtocol?

    /// all items in the cart
    var items: [ChosenItem] = []
    var itemsCount: Int {
        return items.count
    }

    /// with green checkmark selected items
    var selectedItems = SelectedItems(items: [])
    lazy var totalPrice = selectedItems.totalPrice

    // MARK: Init

    init(viewController: CartVC? = nil /*router: HomeRouterProtocol*/) {
        self.view = viewController
        //        self.router = router
    }

    // MARK: Methods

    func getItem(at index: Int) -> ChosenItem {
        return items[index]
    }

    /// mock data
    func setData() {
        items = [ChosenItem(image: "imgProduct", bigTitle: "0. Air pods max by Apple", smallTitle: "Variant: Grey", price: 100.00),
                 ChosenItem(image: "imgProduct", bigTitle: "1. Air pods pro by Apple", smallTitle: "Variant: Grey", price: 150.00),
                 ChosenItem(image: "imgProduct", bigTitle: "2. Air pods fail by honor", smallTitle: "Variant: Grey", price: 399.99),
                 ChosenItem(image: "imgProduct", bigTitle: "3. Air pods middle by Apple", smallTitle: "Variant: Grey", price: 599.99)
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

    // MARK: Methods - Managing of cart

    func updateCell(at index: IndexPath) {
        let itemInfo = getItem(at: index.row)
        view?.updateCellInfo(at: index, with: itemInfo)
    }

    func updateTotals() {
        totalPrice = selectedItems.totalPrice
        view?.updateTotalLabel(with: totalPrice)
    }

    func updateSelectedItems() {
        selectedItems.items = items.filter { $0.isSelected }
    }

    func selectCell(at index: Int) {
        let item = items[index]
        selectedItems.items.append(item)
        updateTotals()
    }

    func deselectCell(at index: Int) {
        if !selectedItems.items.isEmpty {
            let item = items[index]
            selectedItems.items.removeAll { $0.bigTitle == item.bigTitle }
            updateTotals()
        }
    }

    func deleteItem(at indexPath: IndexPath, tableView: UITableView) {
        if !items.isEmpty {
            let item = items[indexPath.row]
            deselectCell(at: indexPath.row)
            items.removeAll { $0.bigTitle == item.bigTitle }
            view?.deleteCell(at: indexPath)
        }
    }

    // MARK: Methods - Selector for buttons

    func tappedPlusButton(at index: IndexPath) {
        items[index.row].numberOfItemsToBuy += 1
        updateCell(at: index)
        view?.reloadTableRows(at: index)
        updateSelectedItems()
    }

    func tappedMinusButton(at index: IndexPath) {
        /// to improve: by setting "1 >= 1" we can reach the value of 0 to make the cell inactive (but not deleted from the cart yet -> UX question
        if items[index.row].numberOfItemsToBuy > 1 {
            items[index.row].numberOfItemsToBuy -= 1
            updateCell(at: index)
            view?.reloadTableRows(at: index)
            updateSelectedItems() 
            updateTotals()
        }
    }

    func tappedCheckmarkButton(at index: IndexPath) {
        items[index.row].isSelected.toggle()
        let item = items[index.row]
        updateCell(at: index)
        if (item.isSelected) {
            self.selectCell(at: index.row)
        } else {
            self.deselectCell(at: index.row)
        }
    }
}
