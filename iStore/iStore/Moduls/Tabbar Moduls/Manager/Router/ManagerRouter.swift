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

    var navigationController: UINavigationController
    var moduleBuilder: (any ManagerBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: ManagerBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

    func initialViewController() {
        if let managerVC = moduleBuilder?.createManagerModule(router: self) {
            navigationController.viewControllers = [managerVC]
        }
    }

    func start() {
        guard let managerVC = moduleBuilder?.createManagerModule(router: self) else { return }
                navigationController.viewControllers = [managerVC]
    }

    func showProductManagerVC() {
        guard let productVC = moduleBuilder?.createProductManagerVC() else { return }
        navigationController.pushViewController(productVC, animated: true)
    }

    func showCategoryManagerVC() {
        guard let categoryVC = moduleBuilder?.createCategoryManagerVC() else { return }
        navigationController.pushViewController(categoryVC, animated: true)
    }
}
