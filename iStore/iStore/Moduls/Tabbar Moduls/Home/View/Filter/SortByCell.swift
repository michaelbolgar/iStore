//
//  SortByCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

protocol SortByCellDelegate: AnyObject{
    func radioButtonTapped()
}

class SortByCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = String(describing: SortByCell.self)
 
    var titleLabel: UILabel!
    var radioButton: UIButton!
    
    weak var delegate: SortByCellDelegate?
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: FilterOption, isSelected: Bool) {
        radioButton.isSelected = isSelected
        titleLabel.text = model.title
//        radioButton = model.button
        titleLabel.textColor = isSelected ? .systemBlue : .black
    }
    
    private func addTargets() {
        radioButton.addTarget(self, action: #selector(radioButtonTapped), for: .touchUpInside)
    }
    
    @objc func radioButtonTapped() {
        delegate?.radioButtonTapped()
    }
    
    func setupViews() {
        radioButton = UIButton()
        radioButton.setupAsRadioButton()
        contentView.addSubview(radioButton)
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        
        // Layout constraints
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            radioButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            radioButton.widthAnchor.constraint(equalToConstant: 24),
            radioButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: radioButton.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

