import UIKit

// MARK: - ProfileRouterProtocol

protocol ProfileRouterProtocol: BaseRouter {
    func start()
    func showChangePhotoVC()
//    func initialViewController()
    // добавить функции для навигации
}

// MARK: ManagerRouter

final class ProfileRouter: ProfileRouterProtocol {
    
    let navigationController: UINavigationController
    var moduleBuilder: (any ProfileBuilderProtocol)?
    private let factory: AppFactory

    init(navigationController: UINavigationController,
         factory: AppFactory,
         builder: ProfileBuilderProtocol) {
        self.navigationController = navigationController
        self.moduleBuilder = builder
        self.factory = factory
    }

//    func initialViewController() {
//        if let profileVC = moduleBuilder?.createProfileModule(router: self) {
//            navigationController.viewControllers = [profileVC]
//        }
//    }

    func start() {
        if let profileVC = moduleBuilder?.createProfileModule(router: self) {
            navigationController.viewControllers = [profileVC]
        }
    }
    
    func showChangePhotoVC() {
//        if let changePhotoVC = moduleBuilder?.createChangePhotoModule(router: self) {
//            changePhotoVC.modalPresentationStyle = .fullScreen
//
//            // Предполагаем, что ваш UINavigationController вложен в UITabBarController
//            if let tabBarController = navigationController.tabBarController {
//                // Представляем модально от активного контроллера в UITabBarController
//                tabBarController.selectedViewController?.present(changePhotoVC, animated: true, completion: nil)
//            } else {
//                // Если вдруг UITabBarController недоступен, представляем от navigationController
//                navigationController.present(changePhotoVC, animated: true, completion: nil)
//            }
//        }
    }
}
