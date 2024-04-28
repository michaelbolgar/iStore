import UIKit

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: BaseRouter {
    func start()
    func showSearchVC(searchText: String)
    func showCartVC()
    func showDetailsVC()
}

// MARK: HomeRouter

final class HomeRouter: HomeRouterProtocol {

    var navigationController: UINavigationController
    var moduleBuilder: (any HomeBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: HomeBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

    func start() {
        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
            navigationController.viewControllers = [homeVC]
        }
    }

    func showSearchVC(searchText: String) {
//        guard let searchVC = moduleBuilder?.createSearchVC(searchText: searchText) else { return }
//        navigationController.pushViewController(searchVC, animated: true)
    }

    func showCartVC() {
        // code
    }

    func showDetailsVC() {
        // code
    }
}
