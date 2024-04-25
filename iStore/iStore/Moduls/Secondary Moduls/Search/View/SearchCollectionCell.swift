//
//  SearchCell.swift
//  iStore
//
//  Created by Maryna Bolotska on 17/04/24.
//

import UIKit

class SearchCollectionCell: UICollectionViewCell {

    // MARK: Properties

    static let identifier = "SearchCollectionViewCell"

    // MARK: UI Elements

    private let productImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        return image
    }()

    private let productLabel = UILabel.makeLabel(text: nil,
                                                 font: UIFont.InterRegular(ofSize: 12),
                                                 textColor: UIColor.darkGray,
                                                 numberOfLines: 1,
                                                 alignment: .left)

    private let priceLabel = UILabel.makeLabel(text: nil,
                                               font: UIFont.InterSemiBold(ofSize: 14),
                                               textColor: UIColor.customDarkGray,
                                               numberOfLines: 1,
                                               alignment: .left)

    private let buyButton = UIButton.makeButton(text: "Add to card",
                                                buttonColor: ButtonColor.green,
                                                titleColor: .white,
                                                titleSize: 12,
                                                width: 144,
                                                height: 31,
                                                cornerRadius: 4)

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backLightGray
        view.layer.cornerRadius = 6
        return view
    }()

    //MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
        setupShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: Methods

     func set(info: Product) {
        let pictureName = info.picture ?? "Buy"
        productImage.image = UIImage(named: pictureName)
        productLabel.text = info.description
        priceLabel.text = "$\(info.price ?? 0)"
    }

    private func setupShadow() {
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowOffset = CGSize(width: 0, height: 2)
        backView.layer.shadowRadius = 1
    }

    private func configure() {
        contentView.addSubview(backView)
        [productImage, productLabel, buyButton, priceLabel].forEach { backView.addSubview($0)}
    }

    private func setupConstraints() {
        productImage.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backView.heightAnchor.constraint(equalToConstant: 217),
            backView.widthAnchor.constraint(equalToConstant: 170),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            productImage.widthAnchor.constraint(equalToConstant: 170),
            productImage.heightAnchor.constraint(equalToConstant: 112),
            productImage.topAnchor.constraint(equalTo: backView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor),

            productLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 13),
            productLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -13),
            productLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 13),

            priceLabel.topAnchor.constraint(equalTo: productLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 13),

            buyButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 11),
            buyButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 13),
            buyButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -13)
        ])
    }
}
