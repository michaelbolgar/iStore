import UIKit

// MARK: ManagerBuilderProtocol

protocol ManagerBuilderProtocol {
    func createManagerModule(router: ManagerRouterProtocol) -> UIViewController
    func createProductManagerVC() -> UIViewController
    func createCategoryManagerVC() -> UIViewController
}

// MARK: ManagerBuilder

final class ManagerBuilder: ManagerBuilderProtocol {

    func createManagerModule(router: ManagerRouterProtocol) -> UIViewController {
        let view = ManagerVC()
        let presenter = ManagerPresenter.self
        view.presenter = presenter as? ManagerPresenterProtocol
        return view
    }

    func createProductManagerVC() -> UIViewController {
        DetailsVC() // заглушка из того что было
    }

    func createCategoryManagerVC() -> UIViewController {
        DetailsVC() // заглушка из того что было
    }
}