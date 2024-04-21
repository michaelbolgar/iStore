import UIKit

// MARK: - ManagerRouterProtocol

protocol ManagerRouterProtocol: BaseRouter {
    func start()
    func showProductManagerVC()
    func showCategoryManagerVC()
    func initialViewController()
}

// MARK: ManagerRouter

final class ManagerRouter: ManagerRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any ManagerBuilderProtocol)?
    private let builder: AppBuilder

    init(navigationController: UINavigationController,
         factory: AppBuilder,
         builder: ManagerBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.builder = factory
    }

    func initialViewController() {
        if let managerVC = moduleBuilder?.createManagerModule(router: self) {
            navigationController.viewControllers = [managerVC]
        }
    }

    func start() {
        navigationController.viewControllers = [builder.makeManagerVC()]
    }

    func showProductManagerVC() {
        // code
    }

    func showCategoryManagerVC() {
        // code
    }
}
