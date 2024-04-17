import UIKit

final class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.hideKeyboard() // это нужно там где будешь реализовывать функцию по изменению логина и почты
    }
}
