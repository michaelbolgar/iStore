import UIKit


extension UITextView {
    static func makeTextView(height: Double, scroll: Bool) -> UITextView {
            let element = UITextView()
            element.backgroundColor = .lightViolet
            element.font = .InterRegular(ofSize: 16)
            element.textColor = .customDarkGray
            element.isEditable = true
            element.isScrollEnabled = scroll
            element.isSelectable = true
            element.textAlignment = .left
            element.layer.cornerRadius = 8
            element.layer.borderWidth = 1.0
            element.layer.borderColor = UIColor.customLightGray.cgColor
            element.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            element.heightAnchor.constraint(equalToConstant: height)
        ])
            return element
    }
}
