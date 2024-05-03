import UIKit

// MARK: WishlistBuilderProtocol

protocol WishlistBuilderProtocol {
    func createWishlistModule(router: WishlistRouterProtocol) -> UIViewController
    func createCartVC() -> UIViewController // он тут нужен или можно тянуть из Home?
    func createDetailsVC(data: SingleProduct) -> UIViewController // тот же вопрос
}

// MARK: WishlistBuilder

final class WishlistBuilder: WishlistBuilderProtocol {

    func createWishlistModule(router: WishlistRouterProtocol) -> UIViewController {
        let view = WishlistVC()
        let presenter = WishlistPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }

    func createCartVC() -> UIViewController {
        CartVC()
    }

    func createDetailsVC(data: SingleProduct) -> UIViewController {
        DetailsVC(data: data)
    }
}
