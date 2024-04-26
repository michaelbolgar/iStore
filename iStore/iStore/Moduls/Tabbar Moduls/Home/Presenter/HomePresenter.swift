import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
}

final class HomePresenter: HomePresenterProtocol {

    //    weak var view: HomeVCProtocol?

    weak var viewController:  HomeVCProtocol?
    private var service = NetworkingManager.shared

    init(viewController: HomeVCProtocol) {
        self.viewController = viewController
    }
    
    // MARK: - HomePresenterProtocol
    
    func viewDidLoad() {
       // do something
        getCategories()
        getProduct(for: 1)
    }
    
    private func getCategories() {
        service.getCategories { [weak self] result in
            switch result {
            case let .success(resultRequest):
                self?.viewController?.show(category: resultRequest)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getProduct(for id: Int) {
        service.getProduct(for: id) { [weak self]  result in
            switch result {
            case let .success(resultRequest):
                self?.viewController?.show(category: resultRequest)
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
    
}
