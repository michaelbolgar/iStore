import UIKit

// MARK: - WishlistRouterProtocol

protocol WishlistRouterProtocol: BaseRouter {
    func start()
    func showCartVC()
    func showDetailsVC()
    func initialViewController()
}

// MARK: WishlistRouter

final class WishlistRouter: WishlistRouterProtocol {

    let navigationController: UINavigationController
    var moduleBuilder: (any WishlistBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: WishlistBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

    func initialViewController() {
        if let wishlistVC = moduleBuilder?.createWishlistModule(router: self) {
            navigationController.viewControllers = [wishlistVC]
        }
    }

    func start() {
        navigationController.viewControllers = [factory.makeWishlistVC()]
    }

    func showCartVC() {
        // code
    }

    func showDetailsVC() {
        // code
    }
}
