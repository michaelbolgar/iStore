//
//  CustomCollectionViewCell.swift
//  iStore
//
//  Created by Alexander Altman on 18.04.2024.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    var colorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Customize the cell's appearance
        backgroundColor = .white
        layer.cornerRadius = 10
        
        addSubview(colorLabel)
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            colorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            colorLabel.topAnchor.constraint(equalTo: topAnchor),
            colorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
