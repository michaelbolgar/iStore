import UIKit

struct UserDefaultManager {
    private let userDefaults = UserDefaults.standard
    
    // Чтение и установка статуса аккаунта менеджера
    var isManagerAccount: Bool {
        get { userDefaults.bool(forKey: UserDefaults.Keys.isManagerAccount) }
        set { userDefaults.set(newValue, forKey: UserDefaults.Keys.isManagerAccount) }
    }
}

final class RootRouter {
    
    private let window: UIWindow?
    private let factory: AppFactory
    private let userDefaults = UserDefaults()
    
    init(window: UIWindow?, builder: AppFactory) {
        self.window = window
        self.factory = builder
    }
    
    func start() {
        //resetOnboardingStatus()
        
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

extension UserDefaults {
    struct Keys {
        static let onboardingCompleted = "isLaunchedBefore"
        static let isManagerAccount = "isManagerAccount"
        static let searchHistory = "searchHistory"
    }
    
    // Чтение и установка состояния онбординга
    var onboardingCompleted: Bool {
        get { return bool(forKey: Keys.onboardingCompleted) }
        set { set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    // Получение и установка истории поиска
    var searchHistory: [String] {
        get { return stringArray(forKey: Keys.searchHistory) ?? [] }
        set { set(newValue, forKey: Keys.searchHistory) }
    }
}


//extension UserDefaults {
//    
//    struct Keys {
//        static let onboardingCompleted = "isLaunchedBefore"
//        static let isManagerAccount = "isManagerAccount"
//        static let searchHistory = "searchHistory"
//    }
//    
//    // Функция для чтения состояния онбординга
//    func getOnboardingCompleted() -> Bool {
//        return bool(forKey: Keys.onboardingCompleted)
//    }
//    
//    // Функция для установки состояния онбординга
//    func setOnboardingCompleted(_ completed: Bool) {
//        set(completed, forKey: Keys.onboardingCompleted)
//    }
//    
//    // Функция для чтения статуса аккаунта менеджера
//    func getIsManagerAccount() -> Bool {
//        return bool(forKey: Keys.isManagerAccount)
//    }
//    
//    // Функция для установки статуса аккаунта менеджера
//    func setIsManagerAccount(_ isManager: Bool) {
//        set(isManager, forKey: Keys.isManagerAccount)
//    }
//    
//    // Функция для получения истории поиска
//    func getSearchHistory() -> [String] {
//        return stringArray(forKey: Keys.searchHistory) ?? []
//    }
//    
//    // Функция для установки истории поиска
//    func setSearchHistory(_ history: [String]) {
//        set(history, forKey: Keys.searchHistory)
//    }
//}
