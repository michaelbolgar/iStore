import UIKit

extension UIView {

    /// needs to be added to every screen contains a text field
    func hideKeyboard() {
        let tap: UIGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        self.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false //иначе при тапе на ячейку задержка в несколько секунд
    }

     func addBorder(y: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: y, width: bounds.width, height: 1.0)
        borderLayer.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(borderLayer)
    }
}
