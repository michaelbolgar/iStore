import UIKit

// MARK: - WishlistRouterProtocol

protocol WishlistRouterProtocol: BaseRouter {
    func start()
    func showCartVC()
    func showDetailsVC(data: SingleProduct)
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

    func start() {
        if let wishlistVC = moduleBuilder?.createWishlistModule(router: self) {
            navigationController.viewControllers = [wishlistVC]
        }
    }

    func showCartVC() {
        if let cartVC = moduleBuilder?.createCartVC() {
            navigationController.pushViewController(cartVC, animated: true)
        }
    }

    func showDetailsVC(data: SingleProduct) {
        if let detailsVC = moduleBuilder?.createDetailsVC(data: data) {
            navigationController.pushViewController(detailsVC, animated: true)
        }
    }
}
