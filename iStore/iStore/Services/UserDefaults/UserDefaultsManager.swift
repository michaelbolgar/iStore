import Foundation

class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    
    // Чтение и установка статуса аккаунта менеджера
    var isManagerAccount: Bool {
        get { userDefaults.bool(forKey: Keys.isManagerAccount) }
        set { userDefaults.set(newValue, forKey: Keys.isManagerAccount) }
    }
    
    // Чтение и установка состояния онбординга
    var onboardingCompleted: Bool {
        get { userDefaults.bool(forKey: Keys.onboardingCompleted) }
        set { userDefaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    // Получение и установка истории поиска
    var searchHistory: [String] {
        get { userDefaults.stringArray(forKey: Keys.searchHistory) ?? [] }
        set { userDefaults.set(newValue, forKey: Keys.searchHistory) }
    }
}

extension UserDefaultsManager {
    enum Keys {
        static let onboardingCompleted = "isLaunchedBefore"
        static let isManagerAccount = "isManagerAccount"
        static let searchHistory = "searchHistory"
    }
}


