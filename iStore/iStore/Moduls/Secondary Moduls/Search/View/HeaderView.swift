//
//  HeaderView.swift
//  iStore
//

import UIKit


class HeaderView: UICollectionReusableView {

    // MARK: UI Elements

    private let searchLabel = UILabel.makeLabel(text: "Last search",
                                                font: UIFont.InterMedium(ofSize: 16),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)

    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear all", for: .normal)
        button.setTitleColor(UIColor.customRed, for: .normal)
        button.titleLabel?.font = UIFont.InterRegular(ofSize: 16)
        return button
    }()

    //MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func layout() {

        [searchLabel, clearButton].forEach {
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            searchLabel.topAnchor.constraint(equalTo: topAnchor),
            searchLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -19),
            clearButton.centerYAnchor.constraint(equalTo: searchLabel.centerYAnchor)
        ])
    }

    // MARK: Selector Methods
    @objc func clearButtonPressed() { }
}

