import UIKit

final class CartTableCell: UITableViewCell, CartCellView {

    // MARK: Properties

    static let identifier = String(describing: CartTableCell.self)
    var presenter: CartCellPresenter?

    private var chosenItem: ChosenItem?
    private let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .ultraLight)

//    var totalsumOfItem: [Double] = []
    var checkmarkAction: ((Bool) -> Void)?
    var totalPriceAction: ((Double) -> Void)?

    // MARK: UI Elements
    private let checkmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor.veryLightGray, renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

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

    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "minus.circle", 
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                 renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle",
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                 renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    let countLabel = UILabel.makeLabel(text: "1", font: UIFont.InterMedium(ofSize: 11),
                                               textColor: UIColor.gray,
                                               numberOfLines: 1,
                                               alignment: .center)

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle", 
                                withConfiguration: configuration)?.withTintColor(UIColor.customDarkGray,
                                                                                renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

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
        presenter = CartCellPresenter(view: self)
        setButtonsTargets()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Methods

    func set(info: ChosenItem) {
        chosenItem = info
        orderImage.image = UIImage(named: info.image)
        bigTitle.text = info.bigTitle
        smallTitle.text = info.smallTitle
        let totalPrice = info.price * info.numberOfItemsToBuy
        pricelabel.text = String(format: "$ %.2f", totalPrice)
        updateCountLabel(count: Int(info.numberOfItemsToBuy))
    }

    func updateCountLabel(count: Int) {
        countLabel.text = "\(count)"
    }

    private func configure() {
        [checkmarkButton, orderImage, bigTitle, smallTitle, pricelabel, countStack].forEach {contentView.addSubview($0)}
        [minusButton, countLabel, plusButton, basketButton].forEach{countStack.addArrangedSubview($0)}
    }

    private func setButtonsTargets() {
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        basketButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

    }

    // MARK: Selector methods

    @objc func deleteButtonTapped() {
        // TO_ASK: зачем тут проверка guard?
        guard let item = chosenItem else { return }
        presenter?.deleteCell()
    }

    @objc func plusButtonTapped() {
        guard let item = chosenItem else { return }
        chosenItem?.numberOfItemsToBuy += 1
        updateCountLabel(count: Int(item.numberOfItemsToBuy) + 1)
        let fullPrice = 1 * item.price
        totalPriceAction?(fullPrice)
    }

    @objc func minusButtonTapped() {
        guard let item = chosenItem else { return }
        /// to improve: by setting "1 >= 1" we can reach the value of 0 to make the cell inactive (but not deleted from the cart yet -> UX question
        if chosenItem?.numberOfItemsToBuy ?? 1 > 1 {
            chosenItem?.numberOfItemsToBuy -= 1
            // TO_ASK: почему в момент тапа не успевает обновляться updateCountLabel ? то же в plusButtonTapped
            updateCountLabel(count: Int(item.numberOfItemsToBuy) - 1)
            let fullPrice = 1 * item.price
            totalPriceAction?(-fullPrice)
        }
    }

    @objc func checkmarkTapped() {
        checkmarkButton.setImage(UIImage(systemName: "checkmark.square.fill", 
                                         withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor.lightGreen, renderingMode: .alwaysOriginal), for: .selected)
        checkmarkButton.isSelected = !checkmarkButton.isSelected
        checkmarkAction?(checkmarkButton.isSelected)

        if checkmarkButton.isSelected {
            guard let item = chosenItem else { return }
            let totalPrice = item.price * item.numberOfItemsToBuy
            totalPriceAction?(totalPrice)
        } else {
            guard let item = chosenItem else { return }
//            print("сколько айтемов мы собираемся удалить из корзины:", item.numberOfItemsToBuy)
//            print ("цена товаров:", item.price)
            let totalPrice = item.price * item.numberOfItemsToBuy
//            print("удаляем следующую сумму:", totalPrice)
            totalPriceAction?(totalPrice)
        }
    }
}

    // MARK: Layout

private extension CartTableCell {

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
