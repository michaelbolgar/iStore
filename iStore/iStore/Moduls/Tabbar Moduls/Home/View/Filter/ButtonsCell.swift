//
//  ButtonsCell.swift
//  iStore
//
//  Created by Kate Kashko on 29.04.2024.
//

import UIKit

protocol ButtonCellDelegate: AnyObject {
    func cancelButtonTapped()
    func saveButtonTapped()
    }


class ButtonsCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = String(describing: ButtonsCell.self)
    weak var delegate: ButtonCellDelegate?
    
    // MARK: - UI
    private let cancelButton = UIButton.makeButtonFlexWidth(text: "Cancel",
                                                         buttonColor: .red,
                                                         titleColor: .white,
                                                         titleSize: 16,
                                                         height: 40,
                                                         cornerRadius: 4)
    
    private let saveButton = UIButton.makeButtonFlexWidth(text: "Save",
                                                         buttonColor: .green,
                                                         titleColor: .white,
                                                         titleSize: 16,
                                                         height: 40,
                                                         cornerRadius: 4)
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
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func cancelButtonTapped() {
        delegate?.cancelButtonTapped()
    }
    
    @objc func saveButtonTapped() {
        delegate?.saveButtonTapped()
    }
    
    private func setupViews() {
        contentView.addSubview(cancelButton)
        contentView.addSubview(saveButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60),
            cancelButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 120),
            
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            saveButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
}
