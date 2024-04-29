import UIKit

// MARK: HomeBuilderProtocol

protocol HomeBuilderProtocol {
    func createHomeModule(router: HomeRouterProtocol) -> UIViewController
    func createSearchVC(searchText: String) -> UIViewController
    func createCartVC() -> UIViewController
    func createDetailsVC(data: SingleProduct) -> UIViewController
    func createFilterVC() -> UIViewController
//    func createPaymentVC() -> UIViewController
}

// MARK: HomeBuilder

final class HomeBuilder: HomeBuilderProtocol {

    func createHomeModule(router: HomeRouterProtocol) -> UIViewController {
        let view = HomeVC()
        let presenter = HomePresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createSearchVC(searchText: String) -> UIViewController {
        CartVC() // заглушка
    }

    func createCartVC() -> UIViewController {
        CartVC()
    }

    func createDetailsVC(data: SingleProduct) -> UIViewController {
        DetailsVC(data: data)
    }
    
    func createFilterVC() -> UIViewController {
        FilterVC()
    }

//    func createPaymentVC() -> UIViewController {
//        PaymentVC()
//    }
}
