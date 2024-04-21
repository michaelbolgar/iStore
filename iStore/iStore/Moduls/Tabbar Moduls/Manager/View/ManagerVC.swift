import UIKit

final class ManagerVC: UIViewController {

    var presenter: ManagerPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard()
    }
}
