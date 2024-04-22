import UIKit

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: BaseRouter {
    func start()
    func showSearchVC(searchText: String)
    func showCartVC()
    func showDetailsVC()
    func initialViewController()
}

// MARK: HomeRouter

final class HomeRouter: HomeRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any HomeBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: HomeBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

    func initialViewController() {
        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
            navigationController.viewControllers = [homeVC]
        }
    }

    func start() {
        navigationController.viewControllers = [factory.makeHomeVC()]
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
