import UIKit

// MARK: - ProfileRouterProtocol

protocol ProfileRouterProtocol: BaseRouter {
    func start()
    func initialViewController()
    // добавить функции для навигации
}

// MARK: ManagerRouter

final class ProfileRouter: ProfileRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any ProfileBuilderProtocol)?
    private let builder: AppBuilder

    init(navigationController: UINavigationController,
         factory: AppBuilder,
         builder: ProfileBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.builder = factory
    }

    func initialViewController() {
        if let profileVC = moduleBuilder?.createProfileModule(router: self) {
            navigationController.viewControllers = [profileVC]
        }
    }

    func start() {
        navigationController.viewControllers = [builder.makeProfileVC()]
    }
}
