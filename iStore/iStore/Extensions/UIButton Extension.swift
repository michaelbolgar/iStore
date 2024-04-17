import UIKit

enum ButtonColor {
    case green
    case gray

    var color: UIColor {
        switch self {
        case .green:
            return .lightGreen
        case .gray:
            return .customLightGray
        }
    }
}

extension UIButton {
    static func makeButton(text: String, 
                           buttonColor: ButtonColor,
                           titleColor: UIColor,
                           titleSize: CGFloat,
                           width: CGFloat,
                           height: CGFloat,
                           cornerRadius: CGFloat? = nil
    ) -> UIButton {

        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = UIFont.InterRegular(ofSize: titleSize)
        button.tintColor = titleColor
        button.widthAnchor.constraint(equalToConstant: width).isActive = true
        button.heightAnchor.constraint(equalToConstant: height).isActive = true
        button.backgroundColor = buttonColor.color
        button.layer.cornerRadius = cornerRadius ?? 0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
