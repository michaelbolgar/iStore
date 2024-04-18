import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let startVC = CartVC()
        let navigationController = UINavigationController(rootViewController: startVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
