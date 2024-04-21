import UIKit

protocol HomeVCProtocol: AnyObject {
//    func reloadCollectionView(section: Int)
}

final class HomeVC: UIViewController {

    var presenter: HomePresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard()
    }
}
