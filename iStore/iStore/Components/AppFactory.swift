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

protocol AppFactory: AnyObject {

    func makeRootRouter(_ window: UIWindow?) -> RootRouter
    func makeTabBar(_ viewControllers: UIViewController...) -> UITabBarController

    func makeHomeVC() -> UIViewController
    func makeWishlistVC() -> UIViewController
    func makeManagerVC() -> UIViewController
    func makeProfileVC() -> UIViewController

    func makeHomeRouter() -> BaseRouter
    func makeWishlistRouter() -> BaseRouter
    func makeManagerRouter() -> ManagerRouter
    func makeProfileRouter() -> BaseRouter
}

final class Factory: AppFactory {

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
        let profileVC = ProfileVC()
        let presenter = ProfilePresenter(view: profileVC)
        profileVC.presenter = presenter
        return profileVC
    }
    
    /// making Routers
    func makeHomeRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("Home", image: "home")
        let moduleBuilder = HomeBuilder()
        let router = HomeRouter(navigationController: navController, factory: self, builder: moduleBuilder)
//        router.initialViewController()
        router.start()
        return router
    }
    
    func makeWishlistRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("Wishlist", image: "heart")
        let moduleBuilder = WishlistBuilder()
        let router = WishlistRouter(navigationController: navController, factory: self, builder: moduleBuilder)
//        router.initialViewController()
        router.start()
        return router
    }
    
    func makeManagerRouter() -> ManagerRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("Manager", image: "paper")
        let moduleBuilder = ManagerBuilder()
        let router = ManagerRouter(navigationController: navController, factory: self, builder: moduleBuilder)
//        router.initialViewController()
        router.start()
        return router
    }
    
    func makeProfileRouter() -> BaseRouter {
        let navController = UINavigationController()
        navController.configureTabBarItem("Profile", image: "profile")
        let moduleBuilder = ProfileBuilder()
        let router = ProfileRouter(navigationController: navController, factory: self, builder: moduleBuilder)
//        router.initialViewController()
        router.start()
        return router
    }
}
