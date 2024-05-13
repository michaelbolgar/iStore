import Foundation

struct ChosenItem {
    let image: String
    let bigTitle: String
    let smallTitle: String
    let price: Double
    var numberOfItemsToBuy: Int = 1

//    var totalPrice: Double {
//        get {
//            return price * Double(numberOfItemsToBuy)
//        }
//    }
}

struct SelectedItems {
    var items: [ChosenItem]

    var totalPrice: Double {
        get {
            return items.reduce (0.0) { $0 + $1.price * Double($1.numberOfItemsToBuy) }
        }
//        set (newTotal) { }
    }
}
