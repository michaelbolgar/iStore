import Foundation

protocol CartPresenterProtocol: AnyObject {
    func getData()
    var itemsCount: Int { get }
    func getItem(at index: Int) -> ChosenItem
}

final class CartPresenter: CartPresenterProtocol {
        weak var view: CartVCProtocol?
        var items: [ChosenItem] = []

    init(viewController: CartVC? = nil) {
        self.view = viewController
    }

    var itemsCount: Int {
        return items.count
    }

    func getItem(at index: Int) -> ChosenItem {
        return items[index]
    }
    func getData() {
        items = [ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
//                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
//                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
//                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99),
//                 ChosenItem(image: "imgProduct", bigTitle: "Air pods max by Apple", smallTitle: "Variant: Grey", price: 1999.99)
        ]
    }
}
