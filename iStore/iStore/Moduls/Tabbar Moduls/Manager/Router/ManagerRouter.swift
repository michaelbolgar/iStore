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
        navigationController.viewControllers = [factory.makeManagerVC()]
    }

    func showProductManagerVC() {
        // code
    }

    func showCategoryManagerVC() {
        // code
    }
}
