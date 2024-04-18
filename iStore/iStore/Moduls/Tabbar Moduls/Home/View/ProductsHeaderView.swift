//
//  ProductsHeaderView.swift
//  iStore
//
//  Created by Kate Kashko on 17.04.2024.
//

import UIKit

final class ProductsHeaderView: UICollectionReusableView {

    //MARK: -> Properties

    private let titleLabel = UILabel.makeLabel(text: "Products",
                                       font: UIFont(name: "Inter-Medium", size: 14),
                                       textColor: UIColor.black,
                                               numberOfLines: nil, alignment: .left)

    private let filtersButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filters", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-Regular", size: 12)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    //MARK: - Action
     @objc private func filtersButtonTapped() {
         print("нажата - Filters")
     }

    //MARK: -> init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: -> Methods
    
    func configureHeader(labelName: String) {
        titleLabel.text = labelName
        }
    private func setViews() {
        addSubview(headerStack)
        headerStack.addSubview(titleLabel)
        headerStack.addSubview(filtersButton)
    }
}

extension ProductsHeaderView{
    private func setupConstraints() {
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: self.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            headerStack.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            filtersButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filtersButton.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor),
            filtersButton.widthAnchor.constraint(equalToConstant: 76),
            filtersButton.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
}


