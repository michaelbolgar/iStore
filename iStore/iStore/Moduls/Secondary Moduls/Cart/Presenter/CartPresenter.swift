import Foundation

protocol CartPresenterProtocol: AnyObject {
    var itemsCount: Int { get }

    func getData()
    func getItem(at index: Int) -> ChosenItem
//    func showPaymentVC()
    func showDetailsVC(data: SingleProduct)
}

final class CartPresenter: CartPresenterProtocol {

//    private let router: HomeRouterProtocol
    weak var view: CartVCProtocol?
    var items: [ChosenItem] = []

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
        items = [ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99)
        ]
    }

//    func showPaymentVC() {
//        router.showPaymentVC()
//    }

    func showDetailsVC(data: SingleProduct) {
//        let detailsVC = DetailsVC(data: mockItem)
//        self.navigationController.pushViewController(detailsVC, animated: true)
    }
}
