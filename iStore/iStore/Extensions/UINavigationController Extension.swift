import UIKit

extension UINavigationController {
    func configureTabBarItem(_ title: String, image: String) {
        self.tabBarItem.title = title
        self.tabBarItem.image = UIImage(named: image)
        self.tabBarItem.selectedImage = UIImage(named: "selected\(image)")?.withRenderingMode(.alwaysOriginal)
        self.view.backgroundColor = .white
        self.isNavigationBarHidden = true
    }
}
