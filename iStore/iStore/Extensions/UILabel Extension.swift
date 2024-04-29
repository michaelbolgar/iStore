import UIKit

extension UILabel {

    static func makeLabel(text: String?,
                          font: UIFont?,
                          textColor: UIColor,
                          numberOfLines: Int?,
                          alignment: NSTextAlignment?) -> UILabel {

        let label = UILabel()
        label.text = text ?? ""
        label.font = font ?? UIFont.systemFont(ofSize: 16)
        label.textColor = textColor
        label.numberOfLines = numberOfLines ?? 0
        label.textAlignment = alignment ?? .left
        label.adjustsFontSizeToFitWidth = false
        label.minimumScaleFactor = 0.5
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}
