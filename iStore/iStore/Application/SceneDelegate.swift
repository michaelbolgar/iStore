import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = ViewController()
        let vc = ViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        window.rootViewController = navigationController
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
