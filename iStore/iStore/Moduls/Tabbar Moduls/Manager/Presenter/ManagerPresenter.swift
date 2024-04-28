import Foundation

protocol ManagerPresenterProtocol {
    init(view: ManagerVCProtocol, router: ManagerRouterProtocol)
    func showProductManagerVC()
    func showCategoryManagerVC()
}

final class ManagerPresenter: ManagerPresenterProtocol {
    
    public weak var view: ManagerVCProtocol?
    private var router: ManagerRouterProtocol

    init(view: ManagerVCProtocol, 
         router: ManagerRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func showProductManagerVC() {
        router.showProductManagerVC()
    }
    
    func showCategoryManagerVC() {
        router.showCategoryManagerVC()
    }
}
