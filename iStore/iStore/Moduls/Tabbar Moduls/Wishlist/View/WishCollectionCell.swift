//
//  WishCollectionCell.swift
//  iStore
//
//  Created by Alexander Altman on 18.04.2024.
//

import UIKit

protocol WishCollectionCellDelegate: AnyObject {
    func buyButtonPressed()
    func heartButtonPressed(at index: Int)
}

final class WishCollectionCell: UICollectionViewCell {
//MARK: - Properties
    var index: Int?
    static let identifier = String(describing: WishCollectionCell.self)
    weak var delegate: WishCollectionCellDelegate?
    let spacing: CGFloat = 12
    
    
   //MARK: - UI elements
    private lazy var productImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        return image
    }()
    
    private lazy var productLabel = UILabel.makeLabel(text: nil,
                                                      font: UIFont.InterRegular(ofSize: 12),
                                                      textColor: UIColor.darkGray,
                                                      numberOfLines: 2,
                                                      alignment: .left)
    
    private lazy var priceLabel = UILabel.makeLabel(text: nil,
                                                    font: UIFont.InterSemiBold(ofSize: 14),
                                                    textColor: UIColor.customDarkGray,
                                                    numberOfLines: 1,
                                                    alignment: .left)
    
    private let buyButton = UIButton.makeButtonFlexWidth(text: "Add to cart",
                                                         buttonColor: ButtonColor.green,
                                                         titleColor: .white,
                                                         titleSize: 12,
                                                         height: 31,
                                                         cornerRadius: 4)
    
    private lazy var heartButton: UIButton = {
        let element = UIButton()
        element.translatesAutoresizingMaskIntoConstraints = false
        return element
    }()
    
    
    private let backView = UIView.makeGreyView(cornerRadius: 6)

    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setupConstraints()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    //MARK: - Methods
    func set(info: Product, at index: Int) {
        self.index = index
        let pictureName = info.picture ?? "Buy"
        productImage.image = UIImage(named: pictureName)
        productLabel.text = info.description
        priceLabel.text = String(format: "$%.2f", info.price ?? 0)
        
        // Update heart button based on favourite status
        if let isFavourite = info.isFavourite, isFavourite {
            heartButton.setImage(UIImage.heart, for: .normal)
        } else {
            heartButton.setImage(UIImage.heartClear, for: .normal)
        }
    }
   
    //MARK: - Private Methods
    private func configure() {
        contentView.addSubview(backView)
        [productImage, productLabel, heartButton, buyButton, priceLabel].forEach { backView.addSubview($0)}
    }
    
    private func addTargets() {
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
    }

    //MARK: - Selector Methods
    @objc func buyButtonTapped() {
        delegate?.buyButtonPressed()
    }
    
    @objc func heartButtonTapped() {
        if let index = index {
            delegate?.heartButtonPressed(at: index)
        }
    }
}

//MARK: - Cell's Constraints
private extension WishCollectionCell {
    func setupConstraints() {
        backView.translatesAutoresizingMaskIntoConstraints = false
        productImage.translatesAutoresizingMaskIntoConstraints = false
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            productImage.topAnchor.constraint(equalTo: backView.topAnchor),
            productImage.leadingAnchor.constraint(equalTo: backView.leadingAnchor),
            productImage.trailingAnchor.constraint(equalTo: backView.trailingAnchor),
            productImage.heightAnchor.constraint(equalTo: backView.heightAnchor, multiplier: 0.5),
            
            productLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            productLabel.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -spacing),
            productLabel.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: spacing),
            
            priceLabel.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            priceLabel.bottomAnchor.constraint(equalTo: buyButton.topAnchor, constant: -spacing / 2),
            
            heartButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: spacing),
            heartButton.centerYAnchor.constraint(equalTo: buyButton.centerYAnchor),
            
            buyButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -spacing),
            buyButton.widthAnchor.constraint(equalTo: backView.widthAnchor, multiplier: 2/3),
            buyButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -spacing)
        ])
    }
}

