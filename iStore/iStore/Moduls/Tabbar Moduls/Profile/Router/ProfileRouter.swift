import UIKit

// MARK: - ProfileRouterProtocol

protocol ProfileRouterProtocol: BaseRouter {
    func start()
//    func initialViewController()
    // добавить функции для навигации
}

// MARK: ManagerRouter

final class ProfileRouter: ProfileRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any ProfileBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: ProfileBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

//    func initialViewController() {
//        if let profileVC = moduleBuilder?.createProfileModule(router: self) {
//            navigationController.viewControllers = [profileVC]
//        }
//    }

    func start() {
        if let profileVC = moduleBuilder?.createProfileModule(router: self) {
            navigationController.viewControllers = [profileVC]
        }
    }
}
