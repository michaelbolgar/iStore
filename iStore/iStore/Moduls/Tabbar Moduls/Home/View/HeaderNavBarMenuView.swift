//
//  HeaderNavBarMenuView.swift
//  iStore
//
//  Created by Kate Kashko on 18.04.2024.
//

import UIKit

final class HeaderNavBarMenuView: UICollectionReusableView {
    
    //MARK: - Private Properties
    private let headerLabel: UILabel = {
        let element = UILabel()
        element.textColor = .systemGray
        element.font = UIFont(name: "Inter-Regular", size: 10)
        return element
    }()
    
    private let locationLabel: UILabel = {
        let element = UILabel()
        element.textColor = .black
        element.font = UIFont(name: "Inter-Medium", size: 12)
        element.text = "Europe - €"
        return element
    }()
    
    private let chevronImageView: UIImageView = {
        let element = UIImageView()
        element.image = UIImage(systemName: "chevron.down")
        element.contentMode = .scaleAspectFill
        element.tintColor = .black
        return element
    }()
    
    private lazy var cartButton: UIButton = {
        let element = UIButton()
        element.tintColor = .black
        element.setBackgroundImage(UIImage(systemName: "cart"), for: .normal)
        element.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        return element
    }()
    
    private lazy var bellButton: UIButton = {
        let element = UIButton()
        element.tintColor = .black
        element.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        element.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        return element
    }()
    
    //MARK: - Action
    @objc private func cartButtonTapped() {
        print("нажата - Cart")
    }
    
    @objc private func bellButtonTapped() {
        print("нажата - Bell")
    }
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    func configureHeader(labelName: String) {
        headerLabel.text = labelName
    }
    
    private func setView() {
        addSubview(headerLabel)
        addSubview(cartButton)
        addSubview(bellButton)
        addSubview(locationLabel)
        addSubview(chevronImageView)
    }
    
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            cartButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            cartButton.heightAnchor.constraint(equalToConstant: 28),
            cartButton.widthAnchor.constraint(equalToConstant: 28),
            cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60)
        ])
        
        NSLayoutConstraint.activate([
            bellButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 10),
            bellButton.heightAnchor.constraint(equalToConstant: 28),
            bellButton.widthAnchor.constraint(equalToConstant: 28),
            bellButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            locationLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            chevronImageView.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            chevronImageView.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 5),
            chevronImageView.heightAnchor.constraint(equalToConstant: 12),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
}
