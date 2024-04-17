import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    // MARK: Private methods
    private func setupTabBar() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        tabBar.tintColor = .lightGreen
        tabBar.unselectedItemTintColor = .customLightGray
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance

        tabBar.layer.borderColor = UIColor.customLightGray.cgColor
        tabBar.layer.borderWidth = 0.5
    }
}
