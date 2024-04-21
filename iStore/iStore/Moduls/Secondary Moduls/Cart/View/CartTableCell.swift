//
//  CartTableCell.swift
//  iStore
//


import UIKit

final class CartTableCell: UITableViewCell, CartCellView {
    //MARK: -> Properties
    static let identifier = "CartTableViewCell"
    var presenter: CartCellPresenter?
    private let configuration = UIImage.SymbolConfiguration(pointSize: 18, weight: .ultraLight)

    private let checkmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))?.withTintColor(UIColor(red: 0.941, green: 0.949, blue: 0.945, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private let orderImage: UIImageView = {
        let view = UIImageView()
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
        button.setImage(UIImage(systemName: "minus.circle", withConfiguration: configuration)?.withTintColor(UIColor(red: 0.224, green: 0.247, blue: 0.259, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration: configuration)?.withTintColor(UIColor(red: 0.224, green: 0.247, blue: 0.259, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private let countLabel = UILabel.makeLabel(text: "1", font: UIFont.InterMedium(ofSize: 11), 
                                               textColor: UIColor.gray,
                                               numberOfLines: 1,
                                               alignment: .center)

    private lazy var basketButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.circle", withConfiguration: configuration)?.withTintColor(UIColor(red: 0.224, green: 0.247, blue: 0.259, alpha: 1), renderingMode: .alwaysOriginal), for: .normal)
        return button
    }()

    private let countStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    //MARK: -> init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setupConstraints()
        presenter = CartCellPresenter(view: self)
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -> Functions

    @objc func plusButtonTapped() {
        presenter?.incrementCount()
    }
    @objc func minusButtonTapped() {
        presenter?.decrementCount()
    }
    @objc func checkmarkTapped() {
        presenter?.checkmarkButtonTapped(checkmarkButton)
    }

    func set(info: ChosenItem) {
        orderImage.image = UIImage(named: info.image)
        bigTitle.text = info.bigTitle
        smallTitle.text = info.smallTitle
        pricelabel.text = "$ \(info.price)"
    }
    func updateCountLabel(count: Int) {
        countLabel.text = "\(count)"
    }

    private func configure() {
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
            countStack.centerYAnchor.constraint(equalTo: pricelabel.centerYAnchor)
        ])
    }

}
