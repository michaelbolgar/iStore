import UIKit

// MARK: HomeBuilderProtocol

protocol HomeBuilderProtocol {
    func createHomeModule(router: HomeRouterProtocol) -> UIViewController
    func createSearchVC(searchText: String) -> UIViewController
    func createCartVC() -> UIViewController
    func createDetailsVC() -> UIViewController
//    func createFilterVC() -> UIViewController
}

// MARK: HomeBuilder

final class HomeBuilder: HomeBuilderProtocol {

    func createHomeModule(router: HomeRouterProtocol) -> UIViewController {
        // get service a network layer
        let viewController = HomeVC()
        let presenter = HomePresenter(viewController: viewController)
        viewController.presenter = presenter
        
        return viewController
    }

    func createSearchVC(searchText: String) -> UIViewController {
        SearchVC()
    }

    func createCartVC() -> UIViewController {
        CartVC()
    }

    func createDetailsVC() -> UIViewController {
        DetailsVC()
    }
    
//    func createFilterVC() -> UIViewController {
//        FilterVC()
//    }
}
