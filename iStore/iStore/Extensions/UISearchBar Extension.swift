//
//  UISearchBar Extension.swift
//  iStore


import UIKit

extension SearchBarView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        toggleSearchButton(with: !searchText.isEmpty)
        delegate?.searchBar(searchBar, textDidChange: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismiss(searchBar)
        delegate?.searchBarSearchButtonClicked(searchBar)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSearchButton(with: !(searchBar.text?.isEmpty ?? true))
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        toggleSearchButton(with: false)
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelAction(with: searchBar)
    }
}

// MARK: - Private Methods
extension SearchBarView {
    private func withAnimation(animatable: @escaping () -> Void) {
        UIView.animate(withDuration: 0.5) {
            animatable()
        }
    }
    
    private func dismiss(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    private func cancelAction(with searchBar: UISearchBar) {
        withAnimation { [self] in
            searchBar.text = nil
            searchBar.showsCancelButton = false
            dismiss(searchBar)
            
            layoutIfNeeded()
        }
    }
}

protocol SearchBarViewDelegate: AnyObject {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
}


final class SearchBarView: UIView {
    weak var delegate: SearchBarViewDelegate?
    var searchIcon: String = "magnifyingglass"
    
    // MARK: - UI Properties
    private lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        let image = UIImage(systemName: searchIcon)?.withTintColor(.clear, renderingMode: .alwaysOriginal)
        search.setImage(image, for: .search, state: .normal)
        search.delegate = self
        search.barTintColor = nil
        search.tintColor = .gray
        search.searchTextPositionAdjustment = UIOffset(horizontal: 5, vertical: 0)
        search.searchTextField.placeholder = "Search"
        search.searchTextField.textColor = .gray
        search.backgroundColor = .clear
        search.searchTextField.backgroundColor = .white
        search.searchTextField.layer.borderColor = UIColor.customLightGray.withAlphaComponent(0.5).cgColor
        search.searchTextField.layer.borderWidth = 1
        search.searchTextField.layer.cornerRadius = 8

        // Set the background image of the searchBar to a transparent image
        search.backgroundImage = UIImage()
        
        return search
    }()
    
    private lazy var searchButton: UIButton = {
        let image = UIImage(systemName: searchIcon)
        let action = UIAction(image: image, handler: searchAction)
        let button = UIButton(type: .system, primaryAction: action)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Initializators
    // Initial code commented by Qew
    //    override init(frame: CGRect) {
    //        super.init(frame: frame)
    //        setView()
    //        setupConstraints()
    //    }
    
    //Qew refactored code
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Private Methods
    private func setView() {
        addSubview(searchBar)
        searchBar.addSubview(searchButton)
    }
    
    private func setupConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Constraints for searchBar to fill its superview
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Constraints for searchButton
            searchButton.topAnchor.constraint(equalTo: searchBar.searchTextField.topAnchor, constant: 5),
            searchButton.leadingAnchor.constraint(equalTo: searchBar.searchTextField.leadingAnchor, constant: 5)
        ])
    }
    
    // MARK: - Private Methods
    private func searchAction(_ action: UIAction) {
        searchBarSearchButtonClicked(searchBar)
    }
    
    // MARK: - Internal Methods
    func toggleSearchButton(with value: Bool) {
        searchButton.isEnabled = value
    }
}
