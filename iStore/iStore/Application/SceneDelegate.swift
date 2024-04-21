import UIKit

/// запуск приложения под прод
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let builder: AppBuilder = Builder()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let rootRouter = builder.makeRootRouter(window!)
        rootRouter.start()
    }
}


/// запуск отдельного экрана без навигационного контроллера
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = ViewController()
//        window.makeKeyAndVisible()
//        self.window = window
//    }
//}
