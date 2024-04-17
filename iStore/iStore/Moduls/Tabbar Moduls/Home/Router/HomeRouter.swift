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
    private let builder: AppBuilder

    init(navigationController: UINavigationController,
         factory: AppBuilder,
         builder: HomeBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.builder = builder
    }

    func initialViewController() {
        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
            navigationController.viewControllers = [homeVC]
        }
    }

    func start() {
        navigationController.viewControllers = [builder.makeHomeVC()]
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
