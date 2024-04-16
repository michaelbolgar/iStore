import UIKit

extension UINavigationController {
    func configureTabBarItem(_ image: String) {
        self.tabBarItem.image = UIImage(named: image)
        self.view.backgroundColor = .white

//        self.tabBarItem.selectedImage = UIImage(named: selectedImage)
    }
}
