import UIKit

// MARK: HomeBuilderProtocol

protocol HomeBuilderProtocol {
    func createHomeModule(router: HomeRouterProtocol) -> UIViewController
    func createSearchVC(searchText: String) -> UIViewController
    func createCartVC() -> UIViewController
    func createDetailsVC() -> UIViewController
}

// MARK: HomeBuilder

final class HomeBuilder: HomeBuilderProtocol {

    func createHomeModule(router: HomeRouterProtocol) -> UIViewController {
        let view = HomeVC()
        let presenter = HomePresenter.self
        view.presenter = presenter as? HomePresenterProtocol
        return view
    }

    func createSearchVC(searchText: String) -> UIViewController {
        SearchVC()
    }

    func createCartVC() -> UIViewController {
        CartVC()
    }

    func createDetailsVC() -> UIViewController {
        DetailsVC()
    }
}
