import UIKit

// MARK: ProfileBuilderProtocol

protocol ProfileBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController
}

// MARK: ProfileBuilder

final class ProfileBuilder: ProfileBuilderProtocol {

    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController {
        let view = ProfileVC()
        let presenter = ProfilePresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
