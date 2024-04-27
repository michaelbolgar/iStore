import UIKit

class CartHeaderView: UITableViewHeaderFooterView {

    static let identifier = String(describing: CartHeaderView.self)

    // MARK: UI Elements
    private let deliveryLabel = UILabel.makeLabel(text: "Delivery to",
                                                  font: UIFont.InterMedium(ofSize: 13),
                                                  textColor: UIColor.customDarkGray,
                                                  numberOfLines: 1,
                                                  alignment: .left)

    private let addressLabel = UILabel.makeLabel(text: "Salatiaga City, Central Java",
                                                 font: UIFont.InterMedium(ofSize: 13),
                                                 textColor: UIColor.customDarkGray,
                                                 numberOfLines: 1,
                                                 alignment: .left)
    private let arrowImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "ArrowDown")
        return image
    }()

    // MARK: Init

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(deliveryLabel)
        addSubview(addressLabel)
        addSubview(arrowImage)
        arrowImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            deliveryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23),
            deliveryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            deliveryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),

            addressLabel.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -10),
            addressLabel.centerYAnchor.constraint(equalTo: deliveryLabel.centerYAnchor),

            arrowImage.centerYAnchor.constraint(equalTo: deliveryLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -23),
            arrowImage.heightAnchor.constraint(equalToConstant: 17),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addBorder(y: 0)
        addBorder(y: bounds.height - 1.0)
    }
}
