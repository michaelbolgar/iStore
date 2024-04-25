//
//  CategoryViewCell.swift
//  iStore
//
//  Created by Kate Kashko on 17.04.2024.
//

import UIKit

final class CategoryViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoryViewCell.self)
    
    // MARK: - Properties
    private lazy var categoryIcon: UIImageView = {
        let element = UIImageView()
        element.contentMode = .center
        element.backgroundColor = .yellow
        element.layer.cornerRadius = 8
        return element
    }()
    
    private lazy var categoryName = UILabel.makeLabel(text: nil,
                                                      font: UIFont.InterRegular(ofSize: 12),
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
    func configureCell(image: String, category: String) {
        categoryIcon.image = UIImage(named: image)
        categoryName.text = category
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
            categoryIcon.widthAnchor.constraint(equalToConstant: 40),
            categoryIcon.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            categoryName.topAnchor.constraint(equalTo: categoryIcon.bottomAnchor, constant: 6),
            categoryName.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            categoryName.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
