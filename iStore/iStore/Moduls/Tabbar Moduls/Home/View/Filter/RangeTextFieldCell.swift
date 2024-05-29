//
//  RangeTextFieldCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

protocol RangeTextFieldCellDelegate: AnyObject {
    func inputMinRange(text: String?)
    func inputMaxRange(text: String?)
}

class RangeTextFieldCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = String(describing: RangeTextFieldCell.self)
    weak var delegate: RangeTextFieldCellDelegate?
    
    private let minTextField = UITextField.makeTextField(
        placeholder: "Min",
        keyboardType: .decimalPad,
        backgroundColor: .white,
        textColor: .black,
        font: UIFont.InterRegular(ofSize: 16),
        height: 40
    )
    
    private let maxTextField = UITextField.makeTextField(
        placeholder: "Max",
        keyboardType: .decimalPad,
        backgroundColor: .white,
        textColor: .black,
        font: UIFont.InterRegular(ofSize: 16),
        height: 40
    )
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        addTargets()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods

    private func addTargets() {
        minTextField.addTarget(self, action: #selector(inputMinRange), for: .editingChanged)
        maxTextField.addTarget(self, action: #selector(inputMaxRange), for: .editingChanged)
    }
    
    @objc func inputMinRange() {
        delegate?.inputMinRange(text: minTextField.text)
    }
    
    @objc func inputMaxRange() {
        delegate?.inputMaxRange(text: maxTextField.text)
    }
    
    private func setupViews() {
        contentView.addSubview(minTextField)
        contentView.addSubview(maxTextField)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            minTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            minTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            minTextField.widthAnchor.constraint(equalToConstant: 140),
            
            maxTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            maxTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            maxTextField.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
}


