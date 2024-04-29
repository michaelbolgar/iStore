import Foundation

protocol DetailsPresenterProtocol {
    func getData(with data: [SingleProduct])
}

final class DetailsPresenter: DetailsPresenterProtocol {

    weak var view: DetailsVCProtocol?
    
    init(view: DetailsVCProtocol? = nil) {
        self.view = view
    }
    func getData(with data: [SingleProduct]) {

        self.view?.displayDetails()
    }
}

