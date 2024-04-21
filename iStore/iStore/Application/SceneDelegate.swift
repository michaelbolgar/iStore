import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = ViewController()
//        window.makeKeyAndVisible()
//        self.window = window
//    }
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let startVC = DetailsVC()
        let navigationController = UINavigationController(rootViewController: startVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        self.window = window
        }
}
