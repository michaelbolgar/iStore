//
//  SortByCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

class SortByCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = String(describing: SortByCell.self)
 
    var titleLabel: UILabel!
    var sortByImage: UIImageView!
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    public func configure(with model: FilterOption, isSelected: Bool) {
        sortByImage.image = isSelected ? UIImage(systemName: "circle.inset.filled") : UIImage(systemName: "circle")
        titleLabel.text = model.title
        titleLabel.textColor = isSelected ? .systemBlue : .black
    }
    
    func setupViews() {
        
        sortByImage = UIImageView()
        sortByImage.tintColor = .systemBlue
        contentView.addSubview(sortByImage)
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        
        // Layout constraints
        sortByImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortByImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sortByImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortByImage.widthAnchor.constraint(equalToConstant: 24),
            sortByImage.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: sortByImage.trailingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}

