//
//  CategoryViewCell.swift
//  iStore
//
//  Created by Kate Kashko on 17.04.2024.
//

import UIKit

final class CategoryViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var identifier: String {"\(Self.self)"}
    
    private lazy var categoryIcon: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        element.layer.cornerRadius = 8
        element.clipsToBounds = true
        return element
    }()
    
    private lazy var categoryName = UILabel.makeLabel(text: nil,
                                                      font: UIFont.InterRegular(ofSize: 10),
                                                      textColor: UIColor.darkGray,
                                                      numberOfLines: 1,
                                                      alignment: .center)
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods

    func configure(with model: Category) {

        categoryName.text = model.name

        /// getting image from server
        guard let imageURL = URL(string: model.image ?? "") else { return }
        ImageDownloader.shared.downloadImage(from: imageURL) { result in
            switch result {
            case .success(let image):
                self.categoryIcon.image = image
            case .failure(let error):
                print("Error fetching image: \(error)")
            }
        }
    }

    private func setViews() {
        addSubview(categoryIcon)
        addSubview(categoryName)
    }
}

    //MARK: - Extensions

private extension CategoryViewCell{
    
    func setupConstraints() {

        categoryIcon.translatesAutoresizingMaskIntoConstraints = false
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryIcon.topAnchor.constraint(equalTo: self.topAnchor),
            categoryIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            categoryIcon.widthAnchor.constraint(equalToConstant: 42),
            categoryIcon.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            categoryName.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 6),
            categoryName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
