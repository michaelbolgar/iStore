//
//  HeaderViewTwo.swift
//  iStore
//

import UIKit

class HeaderView: UICollectionReusableView {
    static var identifier: String {"\(Self.self)"}
    
    // MARK: UI Elements
    let searchlabel = UILabel.makeLabel(text: "Search result for",
                                                font: UIFont.InterRegular(ofSize: 14),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    
    private let filterView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.veryLightGray.cgColor
        return view
    }()
    
    private let filterlabel = UILabel.makeLabel(text: "Filters",
                                                font: UIFont.InterRegular(ofSize: 12),
                                                textColor: UIColor.customDarkGray,
                                                numberOfLines: 1,
                                                alignment: .left)
    
    private let imageFilter: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Filter")
        return image
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
        addSubview(filterView)
        addSubview(searchlabel)
        filterView.addSubview(filterlabel)
        filterView.addSubview(imageFilter)
        searchlabel.translatesAutoresizingMaskIntoConstraints = false
        filterView.translatesAutoresizingMaskIntoConstraints = false
        filterlabel.translatesAutoresizingMaskIntoConstraints = false
        imageFilter.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchlabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            searchlabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            
            filterView.widthAnchor.constraint(equalToConstant: 78),
            filterView.heightAnchor.constraint(equalToConstant: 27),
            filterView.centerYAnchor.constraint(equalTo: searchlabel.centerYAnchor),
            filterView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            filterlabel.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            filterlabel.leadingAnchor.constraint(equalTo: filterView.leadingAnchor, constant: 8),
            
            imageFilter.heightAnchor.constraint(equalToConstant: 12),
            imageFilter.widthAnchor.constraint(equalToConstant: 12),
            imageFilter.trailingAnchor.constraint(equalTo: filterView.trailingAnchor, constant: -8),
            imageFilter.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            
        ])
    }
}
