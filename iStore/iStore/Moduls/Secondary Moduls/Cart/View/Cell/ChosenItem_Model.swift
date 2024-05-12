import Foundation

struct ChosenItem {
    let image: String
    let bigTitle: String
    let smallTitle: String
    let price: Double
    var numberOfItemsToBuy: Double = 1.00
}

struct allItems {
    var items: [ChosenItem]
//    var totalPrice: Double = { items.forEach( складывать суммы и возвращать итог ) }
}
