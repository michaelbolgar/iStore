//
//  SearchFiewldCollectionViewCell.swift
//  iStore
//
//  Created by Kate Kashko on 18.04.2024.
//

import UIKit

final class SearchFieldView: UICollectionViewCell {
    
    //MARK: - Private Properties
    private let mainView: UIView = {
        let element = UIView()
        element.backgroundColor = .white
        element.layer.cornerRadius = 12
        element.layer.masksToBounds = true
        element.layer.borderWidth = 1
        element.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        return element
    }()
    
    private let searchButton: UIButton = {
        let element = UIButton(type: .system)
        element.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        element.tintColor = .systemGray
        return element
    }()
    
    lazy var searchTextField: UITextField = {
        let element = UITextField()
        element.placeholder = NSLocalizedString("Search here ...", comment: "")
        element.backgroundColor = .clear
        element.textAlignment = .left
        element.font = UIFont(name: "Inter-Regular", size: 13)
        element.autocapitalizationType = .words
        element.returnKeyType = .search
        return element
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Methods
    private func setupView() {
        addSubview(mainView)
        mainView.addSubview(searchButton)
        mainView.addSubview(searchTextField)
    }

    private func setConstraints() {

        mainView.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false


        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainView.heightAnchor.constraint(equalToConstant: 40)
        ])

        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            searchButton.topAnchor.constraint(equalTo: mainView.topAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 40),
            searchButton.heightAnchor.constraint(equalTo: mainView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor),
            searchTextField.topAnchor.constraint(equalTo: mainView.topAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            searchTextField.heightAnchor.constraint(equalTo: mainView.heightAnchor)
        ])
    }
}
