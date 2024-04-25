import UIKit
import FirebaseAuth

final class RootRouter {
    
    private let window: UIWindow?
    private let factory: AppFactory
    private let userDefaults = UserDefaultsManager()
    
    init(window: UIWindow?, builder: AppFactory) {
        self.window = window
        self.factory = builder
    }
    
    func start() {
         resetOnboardingStatus()
        
        // insert here code for dark/light mode if needed
        
        
        window?.rootViewController = showMainTabBar()
        window?.makeKeyAndVisible()
        // Проверяем, авторизован ли пользователь
        if Auth.auth().currentUser != nil {
            // Пользователь авторизован
        } else {
            // Пользователь не авторизован
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
    
    func showOnboarding() {
        //        UserDefaults.standard.set(true, forKey: "isLaunchedBefore")
        let onboardingVC = OnboardingVC()
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.isModalInPresentation = true
        window?.rootViewController?.present(onboardingVC, animated: true) {
            self.userDefaults.onboardingCompleted = true
            print("Онбординг завершен, статус сохранен")
        }
    }
    
    func showLoginNavigationController() {
        let loginVC = LoginVC()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.isModalInPresentation = true
        window?.rootViewController?.present(navigationController, animated: true) {
            self.userDefaults.onboardingCompleted = true
        }
    }
    
    //Метод проверки для сброса прохождения Онбординга (установлен и закомментирован в начале start())
    func resetOnboardingStatus() {
        userDefaults.onboardingCompleted = false
        print("Прохождение онбординга сброшено")
    }
}
