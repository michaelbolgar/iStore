import UIKit

final class WishlistVC: UIViewController {

    var presenter: WishlistPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
    }
}
