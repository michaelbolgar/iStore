import UIKit

final class RootRouter {
    
    private let window: UIWindow?
    private let factory: AppFactory
    
    init(window: UIWindow?, builder: AppFactory) {
        self.window = window
        self.factory = builder
    }
    
    func start() {
        
        // insert here code for dark/light mode if needed
        
        window?.rootViewController = showMainTabBar()
        window?.makeKeyAndVisible()
        
        func isUserLoggedIn() -> Bool {
            return false
        }
        
        if !isUserLoggedIn() {
            showLoginNavigationController()
        }
    }
    
    func showMainTabBar() -> UITabBarController {
        return factory.makeTabBar(
            factory.makeHomeRouter().navigationController,
            factory.makeWishlistRouter().navigationController,
            factory.makeManagerRouter().navigationController,
            factory.makeProfileRouter().navigationController
        )
    }
    
    //    func showOnboarding() {
    //        UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
    //        let onboardingVC = OnboardingVC()
    //        onboardingVC.modalPresentationStyle = .fullScreen
    //        onboardingVC.isModalInPresentation = true
    //        window?.rootViewController?.present(onboardingVC, animated: true, completion: nil)
    //    }
    
    func showLoginNavigationController() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isModalInPresentation = true
        window?.rootViewController?.present(navigationController, animated: true, completion: nil)
    }
}
