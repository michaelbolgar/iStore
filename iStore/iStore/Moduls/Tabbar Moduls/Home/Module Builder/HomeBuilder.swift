import UIKit

protocol RouterMainHomeProtocol {
    var navigationController: UINavigationController? { get set }
    var moduleBuilder: HomeBuilderProtocol? { get set }
}

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
    var navigationController: UINavigationController?
    func createHomeModule(router: HomeRouterProtocol) -> UIViewController {
        // get service a network layer
        let view = HomeVC()
        let presenter = HomePresenter(view: view/*, router: router*/)
        view.presenter = presenter
        
        return view
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
