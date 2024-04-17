import UIKit

final class RootRouter {

    private let window: UIWindow?
    private let builder: AppBuilder

    init(window: UIWindow?, builder: AppBuilder) {
        self.window = window
        self.builder = builder
    }

    func start() {

        // insert here code for dark/light mode if needed

        window?.rootViewController = showMainTabBar()
        window?.makeKeyAndVisible()
    }

    func showMainTabBar() -> UITabBarController {
        return builder.makeTabBar(
            builder.makeHomeRouter().navigationController,
            builder.makeWishlistRouter().navigationController,
            builder.makeManagerRouter().navigationController,
            builder.makeProfileRouter().navigationController
        )
    }

//    func showOnboarding() {
//        UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
//        let onboardingVC = OnboardingVC()
//        window?.rootViewController?.present(onboardingVC, animated: true, completion: nil)
//    }

}
