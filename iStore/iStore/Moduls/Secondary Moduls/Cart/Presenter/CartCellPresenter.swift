import UIKit

protocol CartCellView: AnyObject {
    func updateCountLabel(count: Int)
    func set(info: ChosenItem)
}

class CartCellPresenter {
    private weak var view: CartCellView?
    var checkmarkAction: (() -> Void)?
    var updatePriceAction: ((String) -> Void)?
    var deleteButtonAction: (() -> Void)?


    init(view: CartCellView) {
        self.view = view
    }

    #warning("перенести это в CartPresenter?")
    func deleteCell() {
        deleteButtonAction?()
    }
}
