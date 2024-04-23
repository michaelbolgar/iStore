import UIKit

// MARK: ManagerBuilderProtocol

protocol ManagerBuilderProtocol {
    func createManagerModule(router: ManagerRouterProtocol) -> UIViewController
    func createProductManagerVC() -> UIViewController
    func createCategoryManagerVC() -> UIViewController
}

// MARK: ManagerBuilder

final class ManagerBuilder: ManagerBuilderProtocol {
    
    func createManagerModule(router: ManagerRouterProtocol) -> UIViewController {
        let view = ManagerVC()
//        let presenter = ManagerPresenter.self
//        view.presenter = presenter as? ManagerPresenterProtocol
        let presenter = ManagerPresenter(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createProductManagerVC() -> UIViewController {
        ProductVC()
    }
    
    func createCategoryManagerVC() -> UIViewController {
        CategoryVC()
    }
}
