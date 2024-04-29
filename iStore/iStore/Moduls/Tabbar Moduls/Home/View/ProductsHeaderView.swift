//
//  ProductsHeaderView.swift
//  iStore
//
//  Created by Kate Kashko on 17.04.2024.
//

import UIKit
protocol ProductsHeaderViewDelegate: AnyObject {
    func didTapFiltersButton()
}

final class ProductsHeaderView: UICollectionReusableView {

    weak var delegate: ProductsHeaderViewDelegate?
    //MARK: UI Elements

    private let titleLabel = UILabel.makeLabel(text: "Products",
                                               font: UIFont.InterMedium(ofSize: 14),
                                               textColor: UIColor.black,
                                               numberOfLines: nil, alignment: .left)
    
    private let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FilterImage")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let filtersButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
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
    

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: - Methods

    func configureHeader(labelName: String) {
        titleLabel.text = labelName
        }
    private func setViews() {
        addSubview(headerStack)
        addSubview(filterImageView)
        headerStack.addSubview(titleLabel)
        headerStack.addSubview(filtersButton)
    }
    
    //MARK: - Private Methods
    @objc private func filtersButtonTapped() {
//        print("нажата - Filters")
        delegate?.didTapFiltersButton()
    }
}

//MARK: - Extensions

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
        
        NSLayoutConstraint.activate([
              filterImageView.topAnchor.constraint(equalTo: filtersButton.topAnchor),
              filterImageView.centerXAnchor.constraint(equalTo: filtersButton.centerXAnchor),
              filterImageView.widthAnchor.constraint(equalTo: filtersButton.widthAnchor),
              filterImageView.heightAnchor.constraint(equalTo: filtersButton.heightAnchor)
          ])
    }
}


