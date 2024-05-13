import UIKit

protocol CartCellViewProtocol: AnyObject {
    func updateCountLabel()
    func set(info: ChosenItem)
}

class CartCellPresenter {
    private weak var view: CartCellViewProtocol?
    var checkmarkAction: (() -> Void)?
    var updatePriceAction: ((String) -> Void)?
    var deleteButtonAction: (() -> Void)?


    init(view: CartCellViewProtocol) {
        self.view = view
    }

    #warning("перенести это в CartPresenter?")
    func deleteCell() {
        deleteButtonAction?()
    }
}
