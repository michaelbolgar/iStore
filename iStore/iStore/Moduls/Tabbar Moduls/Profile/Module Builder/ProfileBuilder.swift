import UIKit

// MARK: ProfileBuilderProtocol

protocol ProfileBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController
    // добавить функции для навигации по экранам
}

// MARK: ProfileBuilder

final class ProfileBuilder: ProfileBuilderProtocol {

    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController {
        let view = ProfileVC()
        let presenter = ProfilePresenter.self
        view.presenter = presenter as? ProfilePresenterProtocol
        return view
    }
}
