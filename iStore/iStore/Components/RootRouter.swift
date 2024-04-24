import UIKit

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
        
        /// логика показа Onboarding с проверкой, был ли уже пройден онбординг
        // сделать проверку через UserDefaults
        //        showOnboarding()
        
        
        /// логика показа экрана LoginVC с проверкой, авторизован ли пользователь
        //        func isUserLoggedIn() -> Bool {
        //            return false
        //        }
        //        
        //        if !isUserLoggedIn() {
        //            showLoginNavigationController()
        //        }
        
        if userDefaults.onboardingCompleted {
            window?.rootViewController = showMainTabBar()
            print("Онбординг пройден")
        } else {
            showOnboarding()
            print("Онбординг не пройден")
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
