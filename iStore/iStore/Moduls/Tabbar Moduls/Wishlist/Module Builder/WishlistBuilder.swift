import UIKit

// MARK: WishlistBuilderProtocol

protocol WishlistBuilderProtocol {
    func createWishlistModule(router: WishlistRouterProtocol) -> UIViewController
    func createCartVC() -> UIViewController // он тут нужен или можно тянуть из Home?
    func createDetailsVC() -> UIViewController // тот же вопрос
}

// MARK: WishlistBuilder

final class WishlistBuilder: WishlistBuilderProtocol {

    func createWishlistModule(router: WishlistRouterProtocol) -> UIViewController {
        let view = WishlistVC()
        let presenter = WishlistPresenter.self
#warning("поменял тут WishlistPresenterProtocol на WishlistPresenter, может повлиять на логику в дальнейшем")
        view.presenter = presenter as? WishlistPresenter
        return view
    }

    func createCartVC() -> UIViewController {
        CartVC()
    }

    func createDetailsVC() -> UIViewController {
        DetailsVC()
    }
}
