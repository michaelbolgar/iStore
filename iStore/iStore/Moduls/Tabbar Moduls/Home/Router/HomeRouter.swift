import UIKit

// MARK: - HomeRouterProtocol

protocol HomeRouterProtocol: BaseRouter {
    func start()
    func showSearchVC(searchText: String)
    func showCartVC()
    func showDetailsVC(data: SingleProduct)
//    func showPaymentVC()
}

// MARK: HomeRouter

final class HomeRouter: HomeRouterProtocol {

    var navigationController: UINavigationController
    var moduleBuilder: (any HomeBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: HomeBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

    func start() {
        if let homeVC = moduleBuilder?.createHomeModule(router: self) {
            navigationController.viewControllers = [homeVC]
        }
    }

    func showSearchVC(searchText: String) {
//        if let detailsVC = moduleBuilder?.createSearchVC(searchText: <#T##String#>)(data: data) {
//            navigationController.pushViewController(detailsVC, animated: true)
//        }
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

//    func showPaymentVC() {
//        if let paymentVC = moduleBuilder?.createPaymentVC() {
//            navigationController.pushViewController(paymentVC, animated: true)
//        }
//    }
}
