import UIKit

protocol BaseRouter: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
    func back()
    func popToRoot()
}

extension BaseRouter {

    func back() {
        navigationController.popViewController(animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}

protocol AppBuilder: AnyObject {

    func makeRootRouter(_ window: UIWindow?) -> RootRouter
    func makeTabBar(_ viewControllers: UIViewController...) -> UITabBarController

    func makeHomeVC() -> UIViewController
    func makeWishlistVC() -> UIViewController
    func makeManagerVC() -> UIViewController
    func makeProfileVC() -> UIViewController

    func makeHomeRouter() -> BaseRouter
    func makeWishlistRouter() -> BaseRouter
    func makeManagerRouter() -> BaseRouter
    func makeProfileRouter() -> BaseRouter
}

final class Builder: AppBuilder {

    func makeRootRouter(_ window: UIWindow?) -> RootRouter {
        RootRouter(window: window, builder: self)
    }

    func makeTabBar(_ viewControllers: UIViewController...) -> UITabBarController {
        let tabBar = MainTabBarController()
        tabBar.viewControllers = viewControllers
        return tabBar
    }

    /// making ViewControllers
    func makeHomeVC() -> UIViewController {
        HomeVC()
    }
    
    func makeWishlistVC() -> UIViewController {
        WishlistVC()
    }
    
    func makeManagerVC() -> UIViewController {
        ManagerVC()
    }
    
    func makeProfileVC() -> UIViewController {
        ProfileVC()
    }
    
    /// making Routers
    func makeHomeRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("home")
        let moduleBuilder = HomeBuilder()
        let router = HomeRouter(navigationController: navController, factory: self, builder: moduleBuilder)
        router.initialViewController()
        router.start()
        return router
    }
    
    func makeWishlistRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("wishlist")
        let moduleBuilder = WishlistBuilder()
        let router = WishlistRouter(navigationController: navController, factory: self, builder: moduleBuilder)
        router.initialViewController()
        router.start()
        return router
    }
    
    func makeManagerRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("manager")
        let moduleBuilder = ManagerBuilder()
        let router = ManagerRouter(navigationController: navController, factory: self, builder: moduleBuilder)
        router.initialViewController()
        router.start()
        return router
    }
    
    func makeProfileRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("profile")
        let moduleBuilder = ProfileBuilder()
        let router = ProfileRouter(navigationController: navController, factory: self, builder: moduleBuilder)
        router.initialViewController()
        router.start()
        return router
    }
}
