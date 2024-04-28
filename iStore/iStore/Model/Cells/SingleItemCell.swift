//
//  SearchCell.swift
//  iStore
//

import UIKit

class SingleItemCell: UICollectionViewCell {

    // MARK: Properties

    static var identifier: String {"\(Self.self)"}

    // MARK: UI Elements

    private let productImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private let productLabel = UILabel.makeLabel(text: nil,
                                                 font: UIFont.InterRegular(ofSize: 12),
                                                 textColor: UIColor.darkGray,
                                                 numberOfLines: 2,
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
        setupViewConfigure()
        setupConstraints()
        backView.makeCellShadow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Methods
    
    func configure(with model: SingleProduct) {

        productLabel.text = model.title
        priceLabel.text = "$\(model.price ?? 0)"
        
        let correctImageURLString = "https://i.imgur.com/9LFjwpI.jpeg"
        /// getting image from server
        if let firstImageURLString = model.images.first,  let imageURL = URL(string: firstImageURLString ?? "") {
                print("Загрузка изображения с URL: \(imageURL)")
                ImageDownloader.shared.downloadImage(from: imageURL) { result in
                    switch result {
                    case .success(let image):
                        self.productImage.image = image
                    case .failure(let error):
                        print("Ошибка при загрузке изображения: \(error)")
                        guard let newImageURL = URL(string: correctImageURLString) else {return}
                        print(newImageURL)
                        ImageDownloader.shared.downloadImage(from: newImageURL) { result in
                            switch result {
                            case .success(let image):
                                self.productImage.image = image
                            case .failure(let error):
                                print("Ошибка при загрузке изображения: \(error)")
                                
                            }
                        }
                    }
                }
            } else {
                print("Не удалось создать URL для изображения")
            }
    }

    private func setupViewConfigure() {
        contentView.addSubview(backView)
        [productImage, productLabel, buyButton, priceLabel].forEach { backView.addSubview($0)}
    }

    private func setupConstraints() {
        productImage.translatesAutoresizingMaskIntoConstraints = false
        backView.translatesAutoresizingMaskIntoConstraints = false
        productLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
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

            buyButton.topAnchor.constraint(greaterThanOrEqualTo: priceLabel.bottomAnchor, constant: 3),
            buyButton.topAnchor.constraint(lessThanOrEqualTo: priceLabel.bottomAnchor, constant: 11),
            buyButton.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 13),
            buyButton.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -13),

        ])
    }

    private func setImage(pictureURL: String) {

        guard let imageURL = URL(string: pictureURL) else { return }

        ImageDownloader.shared.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                self.productImage.image = image
            case .failure(let error):
                print("Error fetching image: \(error)")
            }
        }
    }
}



