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
//        window?.rootViewController?.present(onboardingVC, animated: true, completion: nil)
//    }

}
