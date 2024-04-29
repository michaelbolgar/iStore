import Foundation
import UIKit

protocol DetailsPresenterProtocol {
    func getData(with data: [SingleProduct])

    func showPaymentVC()
    func showCartVC()
}

final class DetailsPresenter: DetailsPresenterProtocol {

    weak var view: DetailsVCProtocol?
    

    // MARK: Init
    init(view: DetailsVCProtocol? = nil) {
        self.view = view
    }

    // MARK: Methods
    func getData(with data: [SingleProduct]) {
        self.view?.displayDetails()
    }

    func showPaymentVC() {
        let paymentVC = PaymentVC()
//        self.navigationController?.pushViewController(paymentVC, animated: true)
    }

    func showCartVC() {
        // code
    }
}

