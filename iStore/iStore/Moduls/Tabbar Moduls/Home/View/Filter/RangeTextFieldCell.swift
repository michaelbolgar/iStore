//
//  RangeTextFieldCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

class RangeTextFieldCell: UITableViewCell {
    
    static let identifier = String(describing: RangeTextFieldCell.self)
    
    private let minTextField = UITextField.makeTextField(placeholder: "Min",
                                                         keyboardType: .decimalPad,
                                                         backgroundColor: .white,
                                                         textColor: .black,
                                                         font: UIFont.InterRegular(ofSize: 16),
                                                         height: 40
    )
    
    private let maxTextField = UITextField.makeTextField(placeholder: "Max",
                                                         keyboardType: .decimalPad,
                                                         backgroundColor: .white,
                                                         textColor: .black,
                                                         font: UIFont.InterRegular(ofSize: 16),
                                                         height: 40
    )
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(minTextField)
        contentView.addSubview(maxTextField)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            minTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 90),
            minTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            minTextField.widthAnchor.constraint(equalToConstant: 80),
            
            maxTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -90),
            maxTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            maxTextField.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}


