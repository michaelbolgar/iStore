import UIKit
import FirebaseAuth
import Firebase

final class RootRouter {
    
    private let window: UIWindow?
    private let factory: AppFactory
    private let userDefaults = UserDefaultsManager()
    
    init(window: UIWindow?, builder: AppFactory) {
        self.window = window
        self.factory = builder
    }
    
    func start() {

        // insert here code for dark/light mode if needed

        window?.rootViewController = showMainTabBar()
        window?.makeKeyAndVisible()

        // resetOnboardingStatus()

        /// показ Onboarding'a с проверкой, был ли уже пройден онбординг
        if userDefaults.onboardingCompleted {
            print("Онбординг пройден")
        } else {
            print("Онбординг не пройден")
            showOnboarding()
        }

        /// проверяем, авторизован ли пользователь
        if Auth.auth().currentUser != nil {
            print("пользователь авторизован")
        } else {
            print("Пользователь не авторизован")
            showLoginScreen()
        }
    }
    
    func showMainTabBar() -> UITabBarController {
        return factory.makeTabBar(
            factory.makeHomeRouter().navigationController,
            factory.makeWishlistRouter().navigationController,
            factory.makeManagerRouter().navigationController ?? UIViewController(),
            factory.makeProfileRouter().navigationController
        )
    }
    
    func showOnboarding() {
        let onboardingVC = OnboardingVC()
        let navigationController = UINavigationController(rootViewController: onboardingVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isModalInPresentation = true
        window?.rootViewController?.present(navigationController, animated: true) {
            self.userDefaults.onboardingCompleted = true
            print("Онбординг завершен, статус сохранен")
        }
    }
    
    func showLoginScreen() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isModalInPresentation = true
        window?.rootViewController?.present(navigationController, animated: true) {
            self.userDefaults.onboardingCompleted = true
        }
    }
    
    /// метод проверки для сброса прохождения Онбординга (установлен и закомментирован в начале start())
    func resetOnboardingStatus() {
        userDefaults.onboardingCompleted = false
        print("Прохождение онбординга сброшено")
    }
}
