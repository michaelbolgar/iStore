import UIKit

/// main start of the app
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

   var window: UIWindow?
   let factory: AppFactory = Factory()

   func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       guard let windowScene = (scene as? UIWindowScene) else { return }
       window = UIWindow(windowScene: windowScene)
       let rootRouter = factory.makeRootRouter(window!)
       rootRouter.start()
   }
}


/// start of the certain screen for tests / development
//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//
//        let window = UIWindow(windowScene: windowScene)
//        //      window.rootViewController = ViewController()
//        let startVC = SearchVC(searchText: "Classic")
//     //   let cartVC = CartVC()
//        let navigationController = UINavigationController(rootViewController: startVC)
//        window.rootViewController = navigationController
//        window.makeKeyAndVisible()
//        self.window = window
//    }
//}
