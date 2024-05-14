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
    func tappedCheckmarkButton(at index: Int)

    func deleteItem(at indexPath: IndexPath, tableView: UITableView)
    func tappedPlusButton(at index: IndexPath)
    func tappedMinusButton(at index: IndexPath)

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

    // MARK: Methods - Managing of cart

    func updateTotals() {
        totalPrice = selectedItems.totalPrice
        print(totalPrice)
        view?.updateTotalPrice(with: totalPrice)
    }

    func updateCell(at index: IndexPath) {
        let itemInfo = getItem(at: index.row)
        view?.updateCellInfo(at: index, with: itemInfo)
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
        let itemToDelete = items[indexPath.row]
        let priceToRemove = itemToDelete.price * Double(itemToDelete.numberOfItemsToBuy)
        removeFromTotalsByAmount(of: priceToRemove)
        items.remove(at: indexPath.row)

        // логика удаления из выбранного

        tableView.deleteRows(at: [indexPath], with: .bottom)
        tableView.reloadData()
    }

    func tappedPlusButton(at index: IndexPath) {
        // тут ведь уже не надо проверять guard'ом, раз это сделано в VC перед вызовом этой функции?
//        guard let item = chosenItem else { return }
        items[index.row].numberOfItemsToBuy += 1
        updateCell(at: index)
//        addToTotals(at: index.row) //тут не надо добавлять; надо добавлять только когда выделяем чекмаркой
        updateTotals()
    }

    func tappedMinusButton(at index: IndexPath) {
        /// to improve: by setting "1 >= 1" we can reach the value of 0 to make the cell inactive (but not deleted from the cart yet -> UX question
        if items[index.row].numberOfItemsToBuy > 1 {
            items[index.row].numberOfItemsToBuy -= 1
            updateCell(at: index)
            updateTotals()
        }
    }

    func tappedCheckmarkButton(at index: Int) {

//        print("презентер тоже работает")

//        let item = items[index]
//        selectedItems.items.append(item)
//        updateTotals()
    }
}
