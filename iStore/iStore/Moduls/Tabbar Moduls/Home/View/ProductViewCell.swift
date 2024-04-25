//
//  ProductsViewCell.swift
//  iStore
//
//  Created by Kate Kashko on 18.04.2024.
//

import UIKit

final class ProductViewCell: UICollectionViewCell {

    static let identifier = String(describing: ProductViewCell.self)
    // MARK: - UI Elements

    private let productImageView: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFill
        element.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        return element
    }()

    private let titleLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.InterRegular(ofSize: 12)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()

    private let priceLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont.InterRegular(ofSize: 14)
        element.textAlignment = .left
        element.backgroundColor = .clear
        return element
    }()

    private lazy var addToCartButton: UIButton = {
        let element = UIButton()
        element.tintColor = .white
        element.setTitle("Add to cart", for: .normal)
        element.titleLabel?.font = UIFont.InterRegular(ofSize: 13)
        element.layer.cornerRadius = 8
        element.backgroundColor = .lightGreen
        element.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        return element
    }()

    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        //        backgroundColor = .white
        backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        layer.cornerRadius = 12
        setupView()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods
    func configureCell(image: String, title: String, price: String) {
        productImageView.image = UIImage(named: image)
        titleLabel.text = title
        priceLabel.text = price
    }

    private func setupView() {
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(addToCartButton)
    }

    // MARK: - Selector Methods
    @objc private func addToCart() {
        print("нажата - addToCart")
    }
}

    // MARK: Layout

private extension ProductViewCell {

    func setupConstraints() {
        // Disable autoresizing masks for each element to use Auto Layout
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        addToCartButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for productImageView
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: self.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 112)
        ])
        
        // Constraints for titleLabel
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 13),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13)
        ])
        
        // Constraints for priceLabel
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        // Constraints for addToCartButton
        NSLayoutConstraint.activate([
            addToCartButton.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            addToCartButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13),
            addToCartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -13),
            addToCartButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
