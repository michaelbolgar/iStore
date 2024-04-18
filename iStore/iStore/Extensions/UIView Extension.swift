import UIKit

extension UIView {

    /// needs to be added to every screen contains a text field
    func hideKeyboard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false //иначе при тапе на ячейку задержка в несколько секунд
    }

    static func makeGreyView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
