//
//  EmptySearchTableCell.swift
//  iStore
//
//  Created by Maryna Bolotska on 18/04/24.
//

import UIKit

class EmptySearchTableCell: UITableViewCell {
    //MARK: -> Properties
    static let identifier = "EmptySearchTableCell"
        private let timeCircle: UIImageView = {
            let view = UIImageView()
            view.image = UIImage(named: "timecircle")
            return view
        }()
        private let searchLabel = UILabel.makeLabel(text: nil, 
                                                    font: UIFont.InterRegular(ofSize: 14),
                                                    textColor: UIColor.customDarkGray,
                                                    numberOfLines: 1,
                                                    alignment: .left)

        private let closeButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(named: "close_icon"), for: .normal)
            return button
        }()
    //MARK: -> init
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            configure()
            setupConstraints()
            contentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        }
    
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    //MARK: -> Functions
        func set(info: LastSearchData) {
            searchLabel.text = info.enteredWord
        }
    
        private func configure() {
            [timeCircle, searchLabel, closeButton].forEach {contentView.addSubview($0)}
        }
        func setupConstraints() {
            timeCircle.translatesAutoresizingMaskIntoConstraints = false
            closeButton.translatesAutoresizingMaskIntoConstraints = false
    
            NSLayoutConstraint.activate([
                timeCircle.heightAnchor.constraint(equalToConstant: 17.73),
                timeCircle.widthAnchor.constraint(equalToConstant: 17.73),
                timeCircle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                timeCircle.centerYAnchor.constraint(equalTo: centerYAnchor),

                searchLabel.leadingAnchor.constraint(equalTo: timeCircle.trailingAnchor, constant: 14),
                searchLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -14),
                searchLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

                closeButton.heightAnchor.constraint(equalToConstant: 12),
                closeButton.widthAnchor.constraint(equalToConstant: 12),
                closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            ])
        }
    }

