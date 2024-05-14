import Foundation

struct ChosenItem {
    let image: String
    let bigTitle: String
    let smallTitle: String
    let price: Double
    var numberOfItemsToBuy: Int = 1
    var isSelected: Bool = false

    var totalPriceForItem: Double {
        get {
            return price * Double(numberOfItemsToBuy)
        }
    }
}

struct SelectedItems {
    var items: [ChosenItem]

    var totalPrice: Double {
        get {
            return items.reduce (0.0) { $0 + $1.totalPriceForItem }
        }
//        set (newTotal) { }
    }
}
