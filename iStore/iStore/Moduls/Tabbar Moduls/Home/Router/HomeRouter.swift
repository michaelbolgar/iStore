import UIKit

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: BaseRouter {
    func start()
    func showSearchVC(searchText: String)
    func showCartVC()
    func showDetailsVC()
//    func initialViewController()
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

//    func initialViewController() {
//        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
//            navigationController.viewControllers = [homeVC]
//        }
//    }

    func start() {
        guard let viewController = moduleBuilder?.createHomeModule(router: self) else { return }
        navigationController.viewControllers = [viewController]
    }

    func showSearchVC(searchText: String) {
//        guard let searchVC = moduleBuilder?.createSearchVC(searchText: searchText) else { return }
//        navigationController.pushViewController(searchVC, animated: true)
    }

    func showCartVC() {
        guard let cartVC = moduleBuilder?.createCartVC() else { return }
        navigationController.pushViewController(cartVC, animated: true)
    }

    func showDetailsVC() {
        guard let detailsVC = moduleBuilder?.createDetailsVC() else { return }
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
//    func createFilterVC() {
//        guard let filterVC = moduleBuilder?.createDetailsVC() else { return }
//        navigationController?.pushViewController(filterVC, animated: true)
//    }
}
