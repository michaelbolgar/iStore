import UIKit

extension UIViewController {

    func setNavigationBar(title: String) {

        let backButton = UIBarButtonItem(image: UIImage(named: "leftArrow"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))

        navigationItem.hidesBackButton = true
        navigationItem.title = title
        backButton.tintColor = .black
        navigationItem.leftBarButtonItem = backButton

        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont.InterBold(ofSize: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)]
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func hideLeftNavigationItem() {
        navigationItem.setHidesBackButton(true, animated: false)
    }

}

