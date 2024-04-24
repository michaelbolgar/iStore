//
//  HeaderNavBarMenuView.swift
//  iStore
//
//  Created by Kate Kashko on 18.04.2024.
//

import UIKit

final class HeaderNavBarMenuView: UICollectionReusableView, UITableViewDelegate, UITableViewDataSource {
    
    private var dropdownTableView: UITableView!
    private var options = ["Europe - €", "USA - $", "Rus - ₽"]
    
    //MARK: - UI Elements
    private lazy var headerLabel = UILabel.makeLabel(text: nil,
                                                      font: UIFont.InterRegular(ofSize: 10),
                                                      textColor: UIColor.darkGray,
                                                      numberOfLines: 1,
                                                      alignment: .left)
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Europe - €", for: .normal)
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        
        let configuration = UIImage.SymbolConfiguration(scale: .small)
        let chevronImage = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        
        button.setImage(chevronImage, for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.tintColor = UIColor.customDarkGray
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        button.addTarget(self, action: #selector(toggleDropdown), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Buy"), for: .normal)
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bellButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "bell"), for: .normal)
        button.addTarget(self, action: #selector(bellButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    

    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setupConstraints()
        setupDropdownTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private Methods
    func configureHeader(labelName: String) {
        headerLabel.text = labelName
    }
    
    @objc private func cartButtonTapped() {
        print("Cart button tapped")
    }
    
    @objc private func bellButtonTapped() {
        print("Bell button tapped")
    }
    
    @objc private func toggleDropdown() {
        dropdownTableView.isHidden = !dropdownTableView.isHidden
    }
    
    private func setView() {
        addSubview(headerLabel)
        addSubview(cartButton)
        addSubview(bellButton)
        addSubview(locationButton)
    }
    
    private func setupDropdownTableView() {
        dropdownTableView = UITableView()
        dropdownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dropdownTableView.delegate = self
        dropdownTableView.dataSource = self
        dropdownTableView.isHidden = true
        dropdownTableView.layer.masksToBounds = false
        dropdownTableView.layer.shadowColor = UIColor.black.cgColor
        dropdownTableView.layer.shadowOpacity = 0.2
        dropdownTableView.layer.shadowOffset = CGSize(width: 0, height: 2)
        dropdownTableView.layer.shadowRadius = 6
        addSubview(dropdownTableView)
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dropdownTableView.topAnchor.constraint(equalTo: locationButton.bottomAnchor),
            dropdownTableView.leadingAnchor.constraint(equalTo: locationButton.leadingAnchor),
            dropdownTableView.trailingAnchor.constraint(equalTo: locationButton.trailingAnchor),
            dropdownTableView.heightAnchor.constraint(equalToConstant: 120),
            dropdownTableView.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        bellButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            cartButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cartButton.heightAnchor.constraint(equalToConstant: 28),
            cartButton.widthAnchor.constraint(equalToConstant: 28),
            cartButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -60),
            
            bellButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            bellButton.heightAnchor.constraint(equalToConstant: 28),
            bellButton.widthAnchor.constraint(equalToConstant: 28),
            bellButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            locationButton.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 5),
            locationButton.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor)

        ])
    }
    
    //MARK: - UITableView Delegate and DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Inter-Medium", size: 12)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        locationButton.setTitle(options[indexPath.row], for: .normal)
        toggleDropdown()  // Hide dropdown after selection
    }
}
