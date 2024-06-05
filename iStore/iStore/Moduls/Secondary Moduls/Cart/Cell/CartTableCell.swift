import UIKit

protocol CartTableCellDelegate: AnyObject {
    func cartTableCell(_ cell: CartTableCell, didTapCheckmarkButton isSelected: Bool)
}

final class CartTableCell: UITableViewCell {

    // MARK: Properties

    weak var delegate: CartTableCellDelegate?
    static let identifier = String(describing: CartTableCell.self)

    var chosenItem: ChosenItem?
    private let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .ultraLight)

    // MARK: UI Elements

    private let orderImage: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 6
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()

    private let bigTitle = UILabel.makeLabel(text: nil, font: UIFont.InterSemiBold(ofSize: 14),
                                             textColor: UIColor.darkGray,
                                             numberOfLines: 1,
                                             alignment: .left)

    private let smallTitle = UILabel.makeLabel(text: nil, font: UIFont.InterRegular(ofSize: 13),
                                               textColor: UIColor.lightGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    private let pricelabel = UILabel.makeLabel(text: nil, font: UIFont.InterSemiBold(ofSize: 14),
                                               textColor: UIColor.darkGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    lazy var checkmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor.veryLightGray, renderingMode: .alwaysOriginal), for: .normal)
        button.isSelected = false

        button.setImage(UIImage(systemName: "checkmark.square.fill",
                                         withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor.lightGreen, renderingMode: .alwaysOriginal), for: .selected)
        return button
    }()

    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle", 
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                 renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle",
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                 renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle", 
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private let countLabel = UILabel.makeLabel(text: "1", font: UIFont.InterMedium(ofSize: 11),
                                               textColor: UIColor.gray,
                                               numberOfLines: 1,
                                               alignment: .center)

    private let countStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()

    //MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods

    func set(with item: ChosenItem) {
        chosenItem = item
        orderImage.image = UIImage(named: item.image)
        bigTitle.text = item.bigTitle
        smallTitle.text = item.smallTitle
        pricelabel.text = String(format: "$ %.2f", item.price)
        countLabel.text = String(item.numberOfItemsToBuy)
        checkmarkButton.isSelected = item.isSelected
    }
}

    // MARK: Layout

private extension CartTableCell {

    func configure() {
        [checkmarkButton, orderImage, bigTitle, smallTitle, pricelabel, countStack].forEach {contentView.addSubview($0)}
        [minusButton, countLabel, plusButton, basketButton].forEach{countStack.addArrangedSubview($0)}
    }

    func setupConstraints() {
        orderImage.translatesAutoresizingMaskIntoConstraints = false
        checkmarkButton.translatesAutoresizingMaskIntoConstraints = false
        countStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            orderImage.heightAnchor.constraint(equalToConstant: 80),
            orderImage.widthAnchor.constraint(equalToConstant: 80),
            orderImage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            orderImage.leadingAnchor.constraint(equalTo: checkmarkButton.trailingAnchor, constant: 2),

            checkmarkButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkmarkButton.centerYAnchor.constraint(equalTo: orderImage.centerYAnchor),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 35),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 35),

            bigTitle.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            bigTitle.leadingAnchor.constraint(equalTo: orderImage.trailingAnchor, constant: 5),

            smallTitle.topAnchor.constraint(equalTo: bigTitle.bottomAnchor, constant: 5),
            smallTitle.leadingAnchor.constraint(equalTo: orderImage.trailingAnchor, constant: 5),

            pricelabel.bottomAnchor.constraint(equalTo: orderImage.bottomAnchor),
            pricelabel.leadingAnchor.constraint(equalTo: orderImage.trailingAnchor, constant: 5),

            countStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            countStack.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5)
        ])
    }
}
