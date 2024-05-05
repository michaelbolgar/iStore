import Foundation

extension UserDefaultsManager {
    enum Keys {
        static let onboardingCompleted = "isLaunchedBefore"
        static let isManagerAccount = "isManagerAccount"
        static let searchHistory = "searchHistory"
        static let searchHistoryEmpty = "searchHistoryEmpty"
    }
}

class UserDefaultsManager {
    
    private let userDefaults = UserDefaults.standard
    
    /// status if this is a manager account
    var isManagerAccount: Bool {
        get { userDefaults.bool(forKey: Keys.isManagerAccount) }
        set { userDefaults.set(newValue, forKey: Keys.isManagerAccount) }
    }
    
    /// status if onboarding has been shown
    var onboardingCompleted: Bool {
        get { userDefaults.bool(forKey: Keys.onboardingCompleted) }
        set { userDefaults.set(newValue, forKey: Keys.onboardingCompleted) }
    }
    
    /// search history
    #warning("почему тут две функции?")
    var searchHistory: [String] {
        get { userDefaults.stringArray(forKey: Keys.searchHistory) ?? [] }
        set { userDefaults.set(newValue, forKey: Keys.searchHistory) }
    }
    var searchHistoryForEmptySearchScreen: [String] {
        get { userDefaults.stringArray(forKey: Keys.searchHistoryEmpty) ?? [] }
        set { userDefaults.set(newValue, forKey: Keys.searchHistoryEmpty) }
    }

    func addSearchQuery(_ query: String) {
        var history = searchHistory
        if !history.contains(query) {
            history.append(query)
            searchHistory = history
        }
    }

    func clearSearchHistory() {
        searchHistory = []
    }
}
