//
//  UIAlert.swift
//  iStore
//
//  Created by Nikita Shirobokov on 25.04.24.
//

import UIKit

class AlertService {
    static let shared = AlertService()

    private init() {} // Private initializer for singleton

    private var topViewController: UIViewController? {
        // Get the active UIWindowScene
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return nil }
        // Get the active UIWindow from the windowScene
        guard let rootViewController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else { return nil }
        return self.topViewController(with: rootViewController)
    }

    private func topViewController(with root: UIViewController?) -> UIViewController? {
        if let presented = root?.presentedViewController {
            return topViewController(with: presented)
        }
        if let navigation = root as? UINavigationController {
            return topViewController(with: navigation.visibleViewController)
        }
        if let tab = root as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(with: selected)
            }
        }
        return root
    }

    func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        guard let topController = topViewController else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        DispatchQueue.main.async {
            topController.present(alert, animated: true)
        }
    }
}
