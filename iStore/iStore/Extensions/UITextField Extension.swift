import UIKit

enum TextFieldColor {
    case white
    case violet

    var color: UIColor {
        switch self {
        case .white:
            return .white
        case .violet:
            return .lightViolet
        }
    }
}

#warning("добавить паддинг для глаза, скрывающего контент + зачёркивать его согласно макету")

extension UITextField {
    
    static func makeTextField(placeholder: String,
                              keyboardType: UIKeyboardType? = nil,
                              backgroundColor: TextFieldColor,
                              textColor: UIColor,
                              font: UIFont?,
                              height: CGFloat,
                              showHideButton: Bool = false) -> UITextField {

        let textField = UITextField()
        textField.placeholder = placeholder
        textField.textAlignment = .left
        textField.backgroundColor = backgroundColor.color
        textField.layer.cornerRadius = 8
        textField.heightAnchor.constraint(equalToConstant: height).isActive = true
        textField.font = font
        textField.textColor = textColor
        textField.tintColor = .black
        textField.borderStyle = .roundedRect
        textField.keyboardType = keyboardType ?? .default
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false

        /// padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        /// icon for hiding content
        if showHideButton {
                    let button = UIButton(type: .custom)
                    button.setImage(UIImage(systemName: "eye.fill")?.withTintColor(.customLightGray,
                                                                                   renderingMode: .alwaysOriginal),
                                            for: .normal)

                    button.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
                    button.addTarget(textField, action: #selector(toggleSecureTextEntry), for: .touchUpInside)
                    textField.rightView = button
                    textField.rightViewMode = .always
                }

        return textField
    }

    @objc private func toggleSecureTextEntry(_ sender: UIButton) {
            self.isSecureTextEntry.toggle()
        }
}

