import UIKit

protocol CartCellView: AnyObject {
    func updateCountLabel(count: Int)
}

class CartCellPresenter {
    private weak var view: CartCellView?
    var count = 1 {
        didSet {
            view?.updateCountLabel(count: count)
        }
    }
    var checkmarkAction: (() -> Void)?
    var updatePriceAction: ((String) -> Void)?
    var deleteButtonAction: (() -> Void)?
    var amounts = [Double]()

    init(view: CartCellView) {
        self.view = view
    }

    func incrementCount() {
        count += 1
    }

    func decrementCount() {
        if count > 1 {
            count -= 1
        }
    }
    func deleteCell() {
        deleteButtonAction?()
    }

//    func checkmarkButtonTapped(_ sender: UIButton) {
//        sender.setImage(UIImage(systemName: "checkmark.square.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor(red: 0.404, green: 0.769, blue: 0.655, alpha: 1), renderingMode: .alwaysOriginal), for: .selected)
//        sender.isSelected = !sender.isSelected
//    }
}
