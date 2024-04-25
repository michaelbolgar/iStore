import UIKit

// MARK: ProfileBuilderProtocol

protocol ProfileBuilderProtocol {
    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController
//    func createChangePhotoModule(router: ProfileRouterProtocol) -> UIViewController
    func createChangePhotoModule(delegate: ChangePhotoPresenterDelegate) -> UIViewController
}

// MARK: ProfileBuilder

final class ProfileBuilder: ProfileBuilderProtocol {
    
//    func createChangePhotoModule(router: ProfileRouterProtocol) -> UIViewController {
//        let view = ChangePhotoViewController()
//        let presenter = ChangePhotoPresenter()
//        presenter.view = view
////        presenter.delegate = delegate
//        view.presenter = presenter
//        return view
//    }
    
    func createChangePhotoModule(delegate: any ChangePhotoPresenterDelegate) -> UIViewController {
           let view = ChangePhotoViewController()
           let presenter = ChangePhotoPresenter()
           presenter.view = view
           presenter.delegate = delegate
           view.presenter = presenter
           return view
       }
    

    func createProfileModule(router: ProfileRouterProtocol) -> UIViewController {
        let view = ProfileVC()
        let presenter = ProfilePresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
}
