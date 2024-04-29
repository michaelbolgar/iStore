//
//  ButtonsCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

class ButtonsCell: UITableViewCell {
    
    static let identifier = String(describing: ButtonsCell.self)
    
    private let cancelButton = UIButton.makeButtonFlexWidth(text: "Cancel",
                                                            buttonColor: .red,
                                                         titleColor: .white,
                                                         titleSize: 14,
                                                         height: 40,
                                                         cornerRadius: 4)
    
    private let saveButton = UIButton.makeButtonFlexWidth(text: "Save",
                                                            buttonColor: .green,
                                                         titleColor: .white,
                                                         titleSize: 14,
                                                         height: 40,
                                                         cornerRadius: 4)
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            saveButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
